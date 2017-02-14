use db_Intranet2017;

CREATE TABLE system_settings (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY ,
  setting_name VARCHAR(255) NOT NULL UNIQUE ,
  setting_VALUE VARCHAR(255) default ''
);

CREATE TABLE data_types (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY ,
  title VARCHAR(50) UNIQUE NOT NULL ,
  description VARCHAR(255) ,
  type_validation TEXT
);
INSERT INTO data_types (title, description, type_validation) VALUE
  ('word', 'Word', '["word"]'),
  ('text', 'Text', '["printable"]'),
  ('email', 'Email Address', '["trim","email","to_lc"]'),
  ('int', 'Integer', '["integer"]'),
  ('number', 'Number', '["decimal"]'),
  ('bool', 'Boolean', '{"one_of":[[0,1]]}'),
  ('date', 'Date', '["date"]'),
  ('time', 'Time', '["required"]'),
  ('datetime', 'Date and Time', '["datetime"]'),
  ('password', 'Password', '["password",{"min_length":4}]'),
  ('password2', 'Password2', '[{"equal_to_field":"password"}]'),
  ('phone', 'Phone Number', '["phone",{"min_length":11}]'),
  ('json', 'JSON', '["json"]'),
  ('google_auth_token', 'Google Auth Token', '["google_auth_token"]');

CREATE TABLE data_attributes (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY ,
  attribute_name VARCHAR(50) NOT NULL UNIQUE ,
  attribute_title VARCHAR(255) ,
  attribute_group VARCHAR(50) NOT NULL ,
  data_type_id BIGINT UNSIGNED NOT NULL ,
  FOREIGN KEY (data_type_id) REFERENCES data_types (id)
);
INSERT INTO data_attributes (attribute_name, attribute_title, attribute_group, data_type_id) VALUES
  ('email', 'Mobile Phone', 'users', (select id from data_types where title='email') ),
  ('first_name', 'First Name', 'users', (select id from data_types where title='text') ),
  ('last_name', 'Last Name', 'users', (select id from data_types where title='text') ),
  ('mobile_phone', 'Mobile Phone', 'users', (select id from data_types where title='phone') ),
  ('verification_key', 'User Verification Key', 'users', (select id from data_types where title='text') ),
  ('department', 'User Department', 'users', (select id from data_types where title='text') );

CREATE TABLE system_statuses (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY ,
  title VARCHAR(50) UNIQUE NOT NULL ,
  description VARCHAR(255) ,
  system_group VARCHAR(255) NOT NULL ,
  UNIQUE INDEX (title, system_group)
);
INSERT INTO system_statuses (title, description, system_group) VALUES
  ('authentication_pending_activation', 'Authentication Entity pending activation', 'authentication_entities'),
  ('authentication_verified', 'Authentication Entity verification ok', 'authentication_entities'),
  ('authentication_password_reset', 'Authentication Entity reset password', 'authentication_entities'),
  ('user_active', 'User Active', 'users'),
  ('user_disabled', 'User disabled', 'users'),
  ('notification_queued', 'Notification pending release', 'notifications'),
  ('notification_send', 'Notification released', 'notifications'),
  ('notification_processing', 'Notifications busy sending', 'notifications'),
  ('notification_finished', 'Notifications run finished', 'notifications'),
  ('notification_failed', 'Notification queue failed', 'notifications');


### AUTHENTICATION ###
CREATE TABLE authentication_entities (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY ,
  identifier VARCHAR(255) NOT NULL UNIQUE ,
  secret VARCHAR(128) NOT NULL ,
  dbdate_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  data_type_id BIGINT UNSIGNED NOT NULL ,
  system_status_id BIGINT UNSIGNED NOT NULL ,
  is_super BOOLEAN NOT NULL DEFAULT FALSE ,
  FOREIGN KEY (data_type_id) REFERENCES data_types (id)
);
INSERT INTO authentication_entities (identifier, secret, dbdate_created, data_type_id ,system_status_id, is_super) VALUES ('test@example.com', SHA2('test', 512), NOW(), (select id from data_types where title='email'), (select id from system_statuses where title='authentication_verified'), TRUE);
set @last_authentication_entity_id=LAST_INSERT_ID();

CREATE TABLE authentication_sessions (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY ,
  session_token VARCHAR(128) NOT NULL UNIQUE ,
  dbdate_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  dbdate_modified DATETIME NOT NULL ,
  authentication_entity_id BIGINT UNSIGNED NOT NULL ,
  FOREIGN KEY (authentication_entity_id) REFERENCES authentication_entities (id)
);

### USERS ###
CREATE TABLE users (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY ,
  deleted BOOL DEFAULT FALSE ,
  dbdate_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  system_status_id BIGINT UNSIGNED NOT NULL ,
  FOREIGN KEY (system_status_id) REFERENCES system_statuses (id)
);
INSERT INTO users (system_status_id) VALUES ((select id from system_statuses where title='user_active'));
set @last_user_id=LAST_INSERT_ID();

CREATE TABLE user_data (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY ,
  dbdate_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  attribute_value VARCHAR(255) ,
  attribute_id BIGINT UNSIGNED NOT NULL ,
  user_id BIGINT UNSIGNED NOT NULL ,
  FOREIGN KEY (attribute_id) REFERENCES data_attributes (id) ,
  FOREIGN KEY (user_id) REFERENCES users (id) ,
  INDEX (attribute_value)
);
INSERT INTO user_data (attribute_value, attribute_id, user_id) VALUES
  ('test@example.com', (SELECT id from data_attributes where attribute_name='email' and attribute_group='users'), @last_user_id),
  ('John', (SELECT id from data_attributes where attribute_name='first_name' and attribute_group='users'), @last_user_id),
  ('Doe', (SELECT id from data_attributes where attribute_name='last_name' and attribute_group='users'), @last_user_id),
  ('27000000000', (SELECT id from data_attributes where attribute_name='mobile_phone' and attribute_group='users'), @last_user_id),
  ('IT', (SELECT id from data_attributes where attribute_name='department' and attribute_group='users'), @last_user_id);

CREATE TABLE user_authentication_entities (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY ,
  user_id BIGINT UNSIGNED NOT NULL UNIQUE ,
  authentication_entity_id BIGINT UNSIGNED NOT NULL UNIQUE ,
  FOREIGN KEY (user_id) REFERENCES users (id) ,
  FOREIGN KEY (authentication_entity_id) REFERENCES authentication_entities (id)
);
INSERT INTO user_authentication_entities (user_id, authentication_entity_id) VALUES (@last_user_id, @last_authentication_entity_id);

### MODULES ###
CREATE TABLE module_groups (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY ,
  title VARCHAR(50) NOT NULL UNIQUE ,
  description TINYTEXT
);
INSERT INTO module_groups (title, description) VALUES
  ('calendar', 'Calendar'),
  ('phone_book', 'Phone Book'),
  ('system_administration', 'System Administration'),
  ('user_administration', 'User Administration'),
  ('accounts', 'Accounts'),
  ('sales', 'Sales'),
  ('support', 'Support'),
  ('mediaworx', 'MediaWorx IT');

CREATE TABLE modules (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY ,
  title VARCHAR(50) NOT NULL UNIQUE ,
  description TINYTEXT ,
  module_group_id BIGINT UNSIGNED NOT NULL ,
  FOREIGN KEY (module_group_id) REFERENCES module_groups (id)
);
INSERT INTO modules (title, description, module_group_id) VALUES
  ('calendar_view', 'View Calendar', (select id from module_groups where title='calendar')),
  ('calendar_leave_administration', 'Add/Edit/Delete Leave', (select id from module_groups where title='calendar')),
  ('phone_book', 'View Phone Book', (select id from module_groups where title='phone_book')),
  ('user_administration', 'Add/Edit/Delete Users', (select id from module_groups where title='user_administration')),
  ('system_settings', 'Add/Edit/Delete System Settings', (select id from module_groups where title='system_administration')),
  ('tool_ported_numbers_tool', 'Ported Numbers Tool', (select id from module_groups where title='mediaworx')),
  ('database_imports', 'Import data into databases', (select id from module_groups where title='mediaworx'));

CREATE TABLE module_data (
  id BIGINT AUTO_INCREMENT PRIMARY KEY ,
  dbdate_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  attribute_value VARCHAR(255) ,
  attribute_id BIGINT UNSIGNED NOT NULL ,
  module_id BIGINT UNSIGNED NOT NULL ,
  FOREIGN KEY (attribute_id) REFERENCES data_attributes (id) ,
  FOREIGN KEY (module_id) REFERENCES modules (id),
  INDEX (attribute_value)
);

### USER MODULE ACCESS ###
CREATE TABLE user_module_privileges (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY ,
  user_id BIGINT UNSIGNED NOT NULL ,
  module_id BIGINT UNSIGNED NOT NULL ,
  c BOOL NOT NULL DEFAULT FALSE ,
  r BOOL NOT NULL DEFAULT FALSE ,
  u BOOL NOT NULL DEFAULT FALSE ,
  d BOOL NOT NULL DEFAULT FALSE ,
  FOREIGN KEY (user_id) REFERENCES users (id) ,
  FOREIGN KEY (module_id) REFERENCES modules (id) ,
  UNIQUE INDEX (user_id, module_id)
);
INSERT INTO user_module_privileges (user_id, module_id, c, r, u, d) VALUES
  (@last_user_id, (SELECT id FROM modules where title='calendar_view'), TRUE, TRUE, TRUE, TRUE),
  (@last_user_id, (SELECT id FROM modules where title='calendar_leave_administration'), TRUE, TRUE, TRUE, TRUE),
  (@last_user_id, (SELECT id FROM modules where title='phone_book'), TRUE, TRUE, TRUE, TRUE),
  (@last_user_id, (SELECT id FROM modules where title='user_administration'), TRUE, TRUE, TRUE, TRUE),
  (@last_user_id, (SELECT id FROM modules where title='system_settings'), TRUE, TRUE, TRUE, TRUE),
  (@last_user_id, (SELECT id FROM modules where title='tool_ported_numbers_tool'), TRUE, TRUE, TRUE, TRUE),
  (@last_user_id, (SELECT id FROM modules where title='database_imports'), TRUE, TRUE, TRUE, TRUE);

### NOTIFICATIONS ###
CREATE TABLE notification_templates (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY ,
  system_status_id BIGINT UNSIGNED NOT NULL ,
  dbdate_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  FOREIGN KEY (system_status_id) REFERENCES system_statuses (id)
);

CREATE TABLE notification_template_data (
  id BIGINT AUTO_INCREMENT PRIMARY KEY ,
  dbdate_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  attribute_value VARCHAR(255) ,
  attribute_id BIGINT UNSIGNED NOT NULL ,
  notification_template_id BIGINT UNSIGNED NOT NULL ,
  FOREIGN KEY (attribute_id) REFERENCES data_attributes (id) ,
  FOREIGN KEY (notification_template_id) REFERENCES notification_templates (id),
  INDEX (attribute_value)
);

### CALENDAR EVENTS ###
CREATE TABLE calendar_events (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY ,
  system_status_id BIGINT UNSIGNED NOT NULL ,
  dbdate_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  FOREIGN KEY (system_status_id) REFERENCES system_statuses (id)
);

CREATE TABLE calendar_event_data (
  id BIGINT AUTO_INCREMENT PRIMARY KEY ,
  dbdate_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  attribute_value VARCHAR(255) ,
  attribute_id BIGINT UNSIGNED NOT NULL ,
  calendar_event_id BIGINT UNSIGNED NOT NULL ,
  FOREIGN KEY (attribute_id) REFERENCES data_attributes (id) ,
  FOREIGN KEY (calendar_event_id) REFERENCES calendar_events (id),
  INDEX (attribute_value)
);