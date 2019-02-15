scheduler
=========

Dependencies
------------

The core dependencies are:

- Ruby 2.5
- rails
- bootstrap
- webpacker
- graphql
- postgres

Development dependencies:

- [rufo](https://github.com/ruby-formatter/rufo)
- [standard](https://github.com/standard/standard)
- [prettier-standard](https://github.com/sheerun/prettier-standard)

Testing dependencies:

- [rspec](https://github.com/rspec/rspec)
- [factory\_bot](https://github.com/thoughtbot/factory_bot_rails)
- [timecop](https://github.com/travisjeffery/timecop)
- [shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers)

Running the app
---------------

To run the app locally, ensure you have Ruby 2.5.3 installed. If not, it can be
installed using `rbenv`:

```shell
rbenv install 2.5.3
```

Issue the following from the project root to set up the project and start the
app on port 3000.

```shell
bin/setup
```

The app is also deployed at [jmromer-booking.herokuapp.com][heroku].

[heroku]: https://jmromer-booking.herokuapp.com

Scope
-----

The app provides a web-based UI for a single user to book appointments with
coaches.

The following assumptions were made to limit scope:

- The app is meant to be used by a single user / "coachee"
- No authentication is needed
- No UI for coaches to input availability needed (realistically this would be desirable)
- Provided seed data provides weekly recurring availability
- Provided seed data represents one month of recurring availability
- When an appointment is booked, that time slot is left in the availability list in order to demo some error handling

Design
------

### UI

The booking UI is at the root url, the appointment-listing interface at
`/appointments`. Each is managed by a stateful React component,
[`BookingApp`][booking] and [`AppointmentsList`][appointments], respectively. As
much as possible, I used functional components for presentational concerns.

[booking]: app/javascript/BookingApp.js
[appointments]: app/javascript/AppointmentsList.js

### Client-side logic

API query functions are defined in [`app/javascript/lib/api.js`][api].

[api]: app/javascript/lib/api.js


### Application logic

```ruby
# config/routes.rb

post "/graphql", to: "graphql#execute"
```
<sup>
  <a href="https://github.com/betterup/betterup-interview-fullstack-jake-romer/blob/master/config/routes.rb#L8-L8">
    config/routes.rb L8 (master)
  </a>
</sup>
<p></p>

#### GraphQL Schema

```ruby
# app/graphql/scheduler_schema.rb

class SchedulerSchema < GraphQL::Schema
  mutation Types::MutationType
  query Types::QueryType
end
```
<sup>
  <a href="https://github.com/betterup/betterup-interview-fullstack-jake-romer/blob/master/app/graphql/scheduler_schema.rb#L3-L6">
    app/graphql/scheduler_schema.rb L3-6 (master)
  </a>
</sup>
<p></p>

##### Mutations

The handler for requests creating a booking is defined in [`app/graphql/mutations/reserve_availability.rb`][mutation]

[mutation]: app/graphql/mutations/reserve_availability.rb

##### Queries

See [`app/graphql/types/query_type.rb`][queries] for the root query definitions.

[queries]: app/graphql/types/query_type.rb

#### Database schema

The Rails application defines three models: `Appointment`, `Availability`, and `Coach`.
A coach record is one-to-many-associated with both `appointments` and
`availabilities` (independently).

Since it seems likely that in practice an application like this would need a way
for coaches to enter their availability, the seed data was used to generate and
persist availability time slots within the given intervals. (In contrast to
persisting the provided times and computing availability on a per-request
basis.)

#### Timezones

All dates and times are normalized to UTC when persisted to the database, but
presented to the user as localized in the coach's approximate
timezone<a href="#fn.1" id="fr.1"><sup>†</sup></a>.

Some presentational localization methods are defined in `LocalizationMixin`. I
opted to include this module directly in the `ApplicationRecord` models rather
than using presenter objects since the logic is minimal.

<a href="#fr.1" id="fn.1"><sup>†</sup></a>_approximate_ because UTC offsets don't map perfectly to timezones due to DST. A more robust approach would be to parse the timezone labels provided in the seed data and mapping these to normalized timezone labels.

#### Appointment Booking

Appointments can be booked from an availability record by invoking
`Availability#book_appointment!`, which destroys the given availability record
and creates the corresponding appointment in a transaction. The logic here is
just minimal enough that an OO approach seems kosher--for anything more
complicated I'd opt for a service object / transaction script.

```ruby
# app/models/availability.rb

def book_appointment!
  transaction do
    appointment =
      coach
        .appointments
        .create(start_dt: start_dt, end_dt: end_dt)
    destroy
    appointment
  end
end
```
<sup>
  <a href="https://github.com/betterup/betterup-interview-fullstack-jake-romer/blob/master/app/models/availability.rb#L11-L20">
    app/models/availability.rb L11-20 (master)
  </a>
</sup>
<p></p>

#### Availability generation

The class method `Availability.build_attrs_within_range` generates an array of
hashes, each with the attributes of an `Availability` record to be persisted.
This could be refactored to be more idiomatic for Ruby, but a bare `loop` will
do in a pinch.

```ruby
# app/models/availability.rb

# Given a specific coach, a day of the week, and start and end times in
# coach's local time, build an array of Availability attribute-hashes suitable
# for persisting, where each attribute hash represents an availability
# timeslot of duration `interval_length_mins` (default: 30 minutes).
#
# Unless a `number_of_weeks` argument is provided, default to a non-recurring
# schedule.
#
# Keyword Arguments:
#
#    coach [Coach]
#    day_of_week [String]: "Wednesday"
#    local_start_time [String]: "05:00AM"
#    local_end_time [String]: "10:00AM"
#    interval_length_mins [Integer]: 30 (default)
#    number_of_weeks [Integer]: 1 (default)
#
# Returns (example):
#
#    [
#      {
#        coach_id: 1,
#        start_dt: <Thu, 07 Feb 2019 22:30:00 UTC +00:00>,
#        end_dt: <Thu, 07 Feb 2019 23:00:00 UTC +00:00>
#      },
#      {. . .},
#    ]
#
```
<sup>
  <a href="https://github.com/betterup/betterup-interview-fullstack-jake-romer/blob/master/app/models/availability.rb#L24-L51">
    app/models/availability.rb L24-51 (master)
  </a>
</sup>
<p></p>


Tests
-----

Issues `bin/rails spec` from the project root to the run the test suite.
Presently only RSpec tests are written.

Notes on style:

- Mostly xUnit four-phase style, I try to leverage the RSpec DSL minimally.
- Not much need for mocking and stubbing or VCR recording in this suite, but I
  do build persistence objects stubbed, where feasible (see [`spec/models/availability_spec.rb`][availability-specs])
- Request specs are defined in [`spec/queries/coach_queries_spec.rb`][request-specs]
- I ran out of time, but the next thing I'd add is React component tests in
  Enzyme and more server-side testing around the `reserveAvailability` mutation.

[request-specs]: spec/queries/coach_queries_spec.rb
[availability-specs]: spec/models/availability_spec.rb
