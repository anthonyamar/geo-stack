# Geo stack
Geo stack is an opiniated Rails stack to build a modern website without the need to deal with the configuration hell.

It was extracted from a project that is providing geo-based data insight for travelers. Thus the PG configuration using geo and search extensions.

Except the geo and search features, this stack is pretty "Rails standard".

## The stack
- Ruby 3.4.x
- Rails 8.0.x
- Postgresql with Postgis, Pgtrgm, Plpsql and Fuzzystrmatch
- Rgeo suite for geo data manipulation
- Pg search and jaro winkler gems for fuzzy search
- TailwindCSS 4 with DaisyUI 5
- ViewComponent
- Stimulus JS
- Turbo 8
- Active Storage
- Importmap
- Devise
- Minitest
- Capybara
- Rubocop
- Mapbox and Leaflet
- PWA ready
- CI ready with Github Actions
- Production ready using Docker (Dockerfile only)
- Cursor ready with full prompt in /.cursor
- Translation ready for FR and EN
- SEO ready using FriendlyId and sitemap_generator

Soon:
- Solid queue
- Solid cache
- Turbo Native iOS and Android template

## Usage
1. Clone the repository
```bash
git clone git@github.com:anthonyamar/geo-stack.git new-app
cd new-app
```

2. Rename the Origin remote url, so you can still merge changes in the futur
```bash
git remote rename origin geo-stack
```

3. Add your origin url (change the git@github.com link for yours)
```bash
git remote add origin git@github.com:username/new-app.git
```

4. Rename the app
Find and replace all `GeoStack` and `geo_stack` with your app name (e.g. `NewApp` and `new_app`)

## Setup and run
Run bin/setup to bundle, yarn install, figaro install, prepare db, and restart server.
```bash
bin/setup
```

Run your server
```bash
bin/dev
```

Visit [localhost:3000](http://localhost:3000/) and Yay 🎉, you're on Rails !

## Configuration and libs
### Theme configuration
Use the [DaisyUI Theme Generator](https://daisyui.com/theme-generator/) to make your theme, then replace the config in `app/assets/tailwind/application.css`. You can also tweak heading, paragraph, link and Pagy style in this file.

You can change Tailwind configuration, i.e. colors, spacing, radius, fonts in this file as well. See [Tailwind theme doc](https://tailwindcss.com/docs/theme)

### FontAwesome
Add your FontAwesome kit in `application.html.erb` to get icon classes.

### SEO and Sitemap
Fill the `config/meta.yml` with all the details to enable meta-tags. You can find an example on how to define meta-tags on a per page basis in `app/views/static_pages/home.html.erb`

Add the URL and collection that you want to have in your sitemap.xml in `config/sitemap.rb` then run
```bash
ruby sitemap.rb
```

### Using geo and search concerns in model
You can include four concerns to get the most of PG extensions. For the example, let's say you have a City model.

Use any or all by adding it in your model:
```ruby
class City < ApplicationRecord
  include GeoCoordinates
  include GeoBoundingBox
  include Geocoderable
  include FuzzySearchable
  # ...
end
```
#### `GeoCoordinates` and `GeoBoundingBox`
These will expose methods for geo-search, like `nearby?`, `nearby()`, `contains?`. You'll need to add geo fields to your model.

In your migration:
```ruby
add_column :cities, :lonlat, :st_point, geographic: true
add_column :cities, :bounding_box_geom, :geometry, geographic: true
add_index :cities, :lonlat, using: :gist
add_index :cities, :bounding_box_geom, using: :gist
```

I advise you to also have the original coordinates as normal float. Not mandatory, but handy sometimes:
```ruby
add_column :destinations, :original_latitude, :float
add_column :destinations, :original_longitude, :float
```

#### `Geocoderable`
Will fetch the result of Geocoder search once, store it in a jsonb field and serves it for you as an OpenStruct when needed. It is meant to increase performances when accessing geo-data without redundancy.

You can force reloading Geocoder config by adding doing `city.save(store_geocoder_data: true)`.

In your migration:
```ruby
add_column :cities, :geocoder_data, :jsonb, default: {}, null: false
add_index :cities, :geocoder_data, using: :gin
```

Then use, i.e `city.geocoder_data.country` to access all the Geocoder methods outputing data.

#### `FuzzySearchable`
Expose a `fuzzy_search_by` class methods so you can do something like:
```ruby
# fuzzy_search_by(attributes, value, threshold: nil, limit: 10)
User.fuzzy_search_by("name", "Kylian", threshold: 0.8, limit: 3)
# => ActiveRecord Collection
# Kylian
# Kyllian
# Kyliann
```

In your migration, index the attributes that you will query:
```ruby
add_index :cities, :name, using: :gin, opclass: :gin_trgm_ops
add_index :users, :name, using: :gin, opclass: :gin_trgm_ops
add_index :users, :email, using: :gin, opclass: :gin_trgm_ops
```

## Production
### Master key
You may need to generate a Rails master key for your production environment.
```bash
rm config/credentials.yml.enc config/master.key
rails credentials:edit
```
Then, fill your `RAILS_MASTER_KEY` environment variable in production with new one created at `config/master.key`

### Environment variables
Don't forget to set production environment for Rails:
```
RAILS_ENV=production
```

### Postgis
In order to push the template in production, you'll need to install a Postgis instance as a database, and add your environment variables like so:
```
DATABASE_HOST=your-database-host-name-or-url
DATABASE_PORT=5432
DATABASE_USER=postgres
DATABASE_PASSWORD=your-password
DATABASE_NAME=you-database-name
```

To install Postgis, you have mostly two main options(works for in development environment and production):
1. Installing yourself all the packages. You can follow the Rgeo guide on this: [Installing Postgis](https://github.com/rgeo/activerecord-postgis-adapter?tab=readme-ov-file#installing-postgis)
2. Using a Docker image. The official [Postgis Docker](https://hub.docker.com/r/postgis/postgis) image only works on x86/amd64 architecture. If you need a Docker image that runs on arm64, you can use [imresamu/postgis](https://hub.docker.com/r/imresamu/postgis) image.

**Troubleshooting Postgis community images on arm64 through Coolify**:
If you're using Coolify as a PaaS, deploying on arm64 servers, here's the steps:
1. Add the [imresamu/postgis](https://hub.docker.com/r/imresamu/postgis) image in the same project of your app, so they can communicate internaly
2. In the General tab, remove the domain, and set the Ports exposes to `5432`.
3. In the advanced tab, uncheck Force Https, and check Consistent Container Names.
4. Setup your Environment Variables like so:
```
POSTGRES_PASSWORD=your-password
POSTGRES_USER=postgres
```
5. In your Ruby on Rails app, set your `DATABASE_HOST` using the suffix of your database name. I.e., by default, it is something like `docker-image-arandomstringof24chars`. Your `DATABASE_HOST` will then be `arandomstringof24chars`
6. Don't forget to restart both your database and your app.

## Merging updates
Merge changes from the `geo-stack`remote configured above:
```bash
git fetch geo-stack
git fetch geo-stack/main
```

## Licence
Geo Stack is released under the [MIT License](https://opensource.org/license/MIT).

## Contributing
Feel free to open issues and PR on this Github repository
