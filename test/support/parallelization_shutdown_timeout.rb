# frozen_string_literal: true

module ParallelizationShutdownTimeout
  DEFAULT_TIMEOUT = 30.0
  POLL_INTERVAL = 0.1
  TERM_GRACE = 2.0

  module_function

  def timeout
    Float(ENV.fetch("TEST_PARALLEL_SHUTDOWN_TIMEOUT", DEFAULT_TIMEOUT))
  end

  def deadline(seconds = timeout)
    Process.clock_gettime(Process::CLOCK_MONOTONIC) + seconds
  end

  def expired?(deadline)
    Process.clock_gettime(Process::CLOCK_MONOTONIC) >= deadline
  end
end

module ParallelizationServerShutdownTimeout
  def shutdown(timeout: ParallelizationShutdownTimeout.timeout)
    sleep ParallelizationShutdownTimeout::POLL_INTERVAL until @queue.empty?

    @queue.close
    deadline = ParallelizationShutdownTimeout.deadline(timeout)
    workers_stopped = condition_met_before_timeout?(deadline) { !active_workers? }
    report_unfinished_results

    workers_stopped
  end

  private

  def condition_met_before_timeout?(deadline)
    until yield
      return false if ParallelizationShutdownTimeout.expired?(deadline)

      sleep ParallelizationShutdownTimeout::POLL_INTERVAL
    end

    true
  end

  def report_unfinished_results
    @in_flight.each_value do |(klass, name, reporter)|
      result = Minitest::Result.from(klass.new(name))
      error = RuntimeError.new("result not reported")
      error.set_backtrace([""])
      result.failures << Minitest::UnexpectedError.new(error)
      reporter.synchronize { reporter.record(result) }
    end
  end
end

module ParallelizationProcessShutdownTimeout
  def shutdown
    remove_already_dead_workers
    @queue_server.shutdown(timeout: ParallelizationShutdownTimeout.timeout)
    wait_for_worker_pool
  ensure
    terminate_lingering_workers
  end

  private

  def remove_already_dead_workers
    dead_worker_pids = @worker_pool.filter_map do |pid|
      Process.waitpid(pid, Process::WNOHANG)
    rescue Errno::ECHILD
      pid
    end

    @queue_server.remove_dead_workers(dead_worker_pids)
  end

  def wait_for_worker_pool
    deadline = ParallelizationShutdownTimeout.deadline

    @worker_pool.each do |pid|
      wait_for_worker(pid, deadline)
    end
  end

  def wait_for_worker(pid, deadline)
    loop do
      result = Process.waitpid(pid, Process::WNOHANG)
      return if result || ParallelizationShutdownTimeout.expired?(deadline)

      sleep ParallelizationShutdownTimeout::POLL_INTERVAL
    end
  rescue Errno::ECHILD
    nil
  end

  def terminate_lingering_workers
    lingering_pids = live_worker_pids
    return if lingering_pids.empty?

    warn "Terminating stuck Rails test workers: #{lingering_pids.join(", ")}"
    signal_workers("TERM", lingering_pids)
    wait_until_terminated(lingering_pids, ParallelizationShutdownTimeout::TERM_GRACE)

    lingering_pids = live_worker_pids
    return if lingering_pids.empty?

    warn "Killing stuck Rails test workers: #{lingering_pids.join(", ")}"
    signal_workers("KILL", lingering_pids)
    wait_until_terminated(lingering_pids, ParallelizationShutdownTimeout::TERM_GRACE)
  end

  def live_worker_pids
    @worker_pool.select do |pid|
      Process.kill(0, pid)
      true
    rescue Errno::ESRCH, Errno::ECHILD
      false
    end
  end

  def signal_workers(signal, pids)
    pids.each { |pid| Process.kill(signal, pid) }
  rescue Errno::ESRCH, Errno::ECHILD
    nil
  end

  def wait_until_terminated(pids, seconds)
    deadline = ParallelizationShutdownTimeout.deadline(seconds)

    until pids.none? { |pid| live_worker?(pid) } || ParallelizationShutdownTimeout.expired?(deadline)
      sleep ParallelizationShutdownTimeout::POLL_INTERVAL
    end
  end

  def live_worker?(pid)
    Process.kill(0, pid)
    true
  rescue Errno::ESRCH, Errno::ECHILD
    false
  end
end

ActiveSupport::Testing::Parallelization::Server.prepend(ParallelizationServerShutdownTimeout)
ActiveSupport::Testing::Parallelization.prepend(ParallelizationProcessShutdownTimeout)
