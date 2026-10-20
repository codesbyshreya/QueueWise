# QueueWise ER Diagram

Paste the Mermaid diagram below into GitHub Markdown or https://mermaid.live to render/export it.

```mermaid
erDiagram
    USERS o|--o{ QUEUE_TICKETS : requests
    LOCATIONS ||--o{ SERVICE_COUNTERS : contains
    SERVICES ||--o{ SERVICE_COUNTERS : provides
    SERVICE_COUNTERS ||--o{ COUNTER_SCHEDULES : follows
    SERVICE_COUNTERS ||--o{ TOKEN_SEQUENCES : allocates
    SERVICE_COUNTERS ||--o{ QUEUE_TICKETS : issues
    QUEUE_TICKETS ||--o{ QUEUE_EVENTS : records
    USERS o|--o{ QUEUE_EVENTS : performs
    QUEUE_TICKETS ||--o| FEEDBACK : receives
    USERS o|--o{ FEEDBACK : submits

    USERS {
      bigint user_id PK
      varchar full_name
      varchar email UK
      varchar password_hash
      enum role
      boolean is_active
    }
    LOCATIONS {
      bigint location_id PK
      varchar location_name UK
      varchar address
      boolean is_active
    }
    SERVICES {
      bigint service_id PK
      varchar service_name UK
      varchar description
      smallint default_service_minutes
      boolean is_active
    }
    SERVICE_COUNTERS {
      bigint counter_id PK
      bigint location_id FK
      bigint service_id FK
      varchar counter_name
      varchar counter_code
      boolean is_active
    }
    COUNTER_SCHEDULES {
      bigint schedule_id PK
      bigint counter_id FK
      tinyint day_of_week
      time opens_at
      time closes_at
      boolean is_closed
    }
    TOKEN_SEQUENCES {
      bigint counter_id PK,FK
      date token_date PK
      int last_number
      timestamp updated_at
    }
    QUEUE_TICKETS {
      bigint ticket_id PK
      bigint customer_id FK
      bigint counter_id FK
      date token_date
      int token_number
      varchar token_code UK
      enum status
      datetime issued_at
      datetime called_at
      datetime service_started_at
      datetime completed_at
    }
    QUEUE_EVENTS {
      bigint event_id PK
      bigint ticket_id FK
      bigint actor_user_id FK
      enum event_type
      datetime event_time
      varchar details
    }
    FEEDBACK {
      bigint feedback_id PK
      bigint ticket_id FK_UK
      bigint customer_id FK
      tinyint rating
      varchar comment
      datetime submitted_at
    }
```

## Relationship notes
- A location contains many counters; each counter belongs to one location.
- Each counter provides one service in this version; a service can be provided by multiple counters.
- A counter has up to one schedule per day of the week.
- A ticket can optionally be associated with a registered customer (walk-ins can be anonymous).
- Every ticket belongs to exactly one counter and can have multiple queue events.
- Each ticket can receive at most one feedback response.
- Actual wait and service duration are derived from timestamps; they are not duplicated as editable columns.
