# frozen_string_literal: true

Excon.defaults[:middlewares].insert(1, Excon::Middleware::RedirectFollower)
