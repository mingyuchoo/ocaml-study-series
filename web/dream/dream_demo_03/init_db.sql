-- Create todos table
CREATE TABLE IF NOT EXISTS todos (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  completed INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample todos
INSERT INTO todos (title, completed) VALUES 
  ('OCaml로 웹 앱 만들기', 1),
  ('Dream 프레임워크 배우기', 1),
  ('Todo 앱 완성하기', 0);
