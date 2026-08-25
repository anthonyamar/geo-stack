# frozen_string_literal: true

# Run with: bin/ci [--sign]
#
# --sign  Run gh signoff after a green CI (requires branch pushed with upstream tracking).

CI_SIGN = ARGV.delete("--sign")

CI.run do
  step "Setup", "bin/setup --skip-server --frozen-lockfile"
  step "Assets: Tailwind + JS", "bin/rails tailwindcss:build && yarn build"
  step "Style: Ruby", "bin/rubocop"
  step "Style: JavaScript", "bin/eslint"
  step "Security: Gem audit", "bin/bundler-audit"
  step "Security: Yarn audit", "bin/yarn-audit"
  step "Security: Brakeman code analysis", "bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error"
  step "Tests: Rails", "bin/rails test"
  step "Tests: System", "bin/rails test:system"

  if CI_SIGN
    # Requires the `gh` CLI and `gh extension install basecamp/gh-signoff`.
    if success?
      step "Signoff: All systems go. Ready for merge and deploy.", "gh signoff"
    else
      failure "Signoff: CI failed. Do not merge or deploy.", "Fix the issues and try again."
    end
  end
end
