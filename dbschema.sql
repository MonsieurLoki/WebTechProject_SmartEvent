CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email VARCHAR(100) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  full_name VARCHAR(100) NOT NULL,
  role VARCHAR(20) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT users_role_chk
    CHECK (role IN ('ATTENDEE', 'ORGANIZER', 'ADMIN'))
);

CREATE TABLE events (
  id SERIAL PRIMARY KEY,
  organizer_id INTEGER NOT NULL,
  title VARCHAR(150) NOT NULL,
  description TEXT,
  date_time TIMESTAMP NOT NULL,
  location VARCHAR(150) NOT NULL,
  capacity INTEGER NOT NULL,
  price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  is_virtual BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT events_capacity_chk
    CHECK (capacity > 0),
  CONSTRAINT events_price_chk
    CHECK (price >= 0),
  CONSTRAINT events_organizer_fk
    FOREIGN KEY (organizer_id)
    REFERENCES users(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

CREATE TABLE registrations (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  event_id INTEGER NOT NULL,
  ticket_type VARCHAR(50) NOT NULL,
  price_paid DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
  registered_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT registrations_price_paid_chk
    CHECK (price_paid >= 0),
  CONSTRAINT registrations_status_chk
    CHECK (status IN ('PENDING', 'CONFIRMED', 'CANCELLED')),
  CONSTRAINT registrations_user_fk
    FOREIGN KEY (user_id)
    REFERENCES users(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT registrations_event_fk
    FOREIGN KEY (event_id)
    REFERENCES events(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT registrations_user_event_uq
    UNIQUE (user_id, event_id)
);

CREATE TABLE feedback (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  event_id INTEGER NOT NULL,
  rating INTEGER NOT NULL,
  comment TEXT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT feedback_rating_chk
    CHECK (rating BETWEEN 1 AND 5),
  CONSTRAINT feedback_user_fk
    FOREIGN KEY (user_id)
    REFERENCES users(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT feedback_event_fk
    FOREIGN KEY (event_id)
    REFERENCES events(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT feedback_user_event_uq
    UNIQUE (user_id, event_id)
);

CREATE TABLE payments (
  id SERIAL PRIMARY KEY,
  registration_id INTEGER NOT NULL UNIQUE,
  amount DECIMAL(10,2) NOT NULL,
  payment_status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
  provider VARCHAR(30) NOT NULL,
  transaction_ref VARCHAR(100),
  paid_at TIMESTAMP,
  CONSTRAINT payments_amount_chk
    CHECK (amount >= 0),
  CONSTRAINT payments_status_chk
    CHECK (payment_status IN ('PENDING', 'PAID', 'FAILED', 'REFUNDED')),
  CONSTRAINT payments_registration_fk
    FOREIGN KEY (registration_id)
    REFERENCES registrations(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);