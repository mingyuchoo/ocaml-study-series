module type DB = Caqti_lwt.CONNECTION
module T = Caqti_type

(* Todo types *)
type todo = {
  id : int;
  title : string;
  completed : bool;
}

let todo_to_yojson {id; title; completed} =
  `Assoc [
    ("id", `Int id);
    ("title", `String title);
    ("completed", `Bool completed);
  ]

(* Database queries for todos *)
let list_todos =
  let query =
    let open Caqti_request.Infix in
    (T.unit ->* T.(t3 int string bool))
    "SELECT id, title, completed FROM todos ORDER BY id DESC" in
  fun (module Db : DB) ->
    let%lwt todos_or_error = Db.collect_list query () in
    let%lwt todos = Caqti_lwt.or_fail todos_or_error in
    Lwt.return (List.map (fun (id, title, completed) -> {id; title; completed}) todos)

let get_todo =
  let query =
    let open Caqti_request.Infix in
    (T.int ->? T.(t3 int string bool))
    "SELECT id, title, completed FROM todos WHERE id = ?" in
  fun id (module Db : DB) ->
    let%lwt todo_or_error = Db.find_opt query id in
    let%lwt todo_opt = Caqti_lwt.or_fail todo_or_error in
    match todo_opt with
    | Some (id, title, completed) -> Lwt.return (Some {id; title; completed})
    | None -> Lwt.return None

let add_todo =
  let query =
    let open Caqti_request.Infix in
    (T.string ->. T.unit)
    "INSERT INTO todos (title, completed) VALUES (?, 0)" in
  fun title (module Db : DB) ->
    let%lwt unit_or_error = Db.exec query title in
    Caqti_lwt.or_fail unit_or_error

let delete_todo =
  let query =
    let open Caqti_request.Infix in
    (T.int ->. T.unit)
    "DELETE FROM todos WHERE id = ?" in
  fun id (module Db : DB) ->
    let%lwt unit_or_error = Db.exec query id in
    Caqti_lwt.or_fail unit_or_error

let toggle_todo =
  let query =
    let open Caqti_request.Infix in
    (T.int ->. T.unit)
    "UPDATE todos SET completed = NOT completed WHERE id = ?" in
  fun id (module Db : DB) ->
    let%lwt unit_or_error = Db.exec query id in
    Caqti_lwt.or_fail unit_or_error

(* Render Todo App UI *)
let render_todo_app request =
  <html>
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Todo App</title>
    <style>
      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
      }
      
      body {
        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        min-height: 100vh;
        padding: 20px;
        display: flex;
        justify-content: center;
        align-items: center;
      }
      
      .container {
        background: white;
        border-radius: 20px;
        box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
        max-width: 600px;
        width: 100%%;
        padding: 40px;
      }
      
      h1 {
        color: #667eea;
        font-size: 2.5rem;
        margin-bottom: 30px;
        text-align: center;
      }
      
      .input-container {
        display: flex;
        gap: 10px;
        margin-bottom: 30px;
      }
      
      input[type="text"] {
        flex: 1;
        padding: 15px 20px;
        border: 2px solid #e0e0e0;
        border-radius: 10px;
        font-size: 1rem;
        transition: border-color 0.3s;
      }
      
      input[type="text"]:focus {
        outline: none;
        border-color: #667eea;
      }
      
      button {
        padding: 15px 30px;
        background: #667eea;
        color: white;
        border: none;
        border-radius: 10px;
        font-size: 1rem;
        font-weight: 600;
        cursor: pointer;
        transition: background 0.3s, transform 0.1s;
      }
      
      button:hover {
        background: #5568d3;
      }
      
      button:active {
        transform: scale(0.98);
      }
      
      .todo-list {
        list-style: none;
      }
      
      .todo-item {
        background: #f8f9fa;
        padding: 20px;
        margin-bottom: 15px;
        border-radius: 10px;
        display: flex;
        align-items: center;
        gap: 15px;
        transition: transform 0.2s, box-shadow 0.2s;
      }
      
      .todo-item:hover {
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
      }
      
      .todo-item.completed {
        opacity: 0.6;
      }
      
      .todo-item.completed .todo-text {
        text-decoration: line-through;
        color: #999;
      }
      
      .todo-checkbox {
        width: 24px;
        height: 24px;
        cursor: pointer;
      }
      
      .todo-text {
        flex: 1;
        font-size: 1.1rem;
        color: #333;
      }
      
      .todo-actions {
        display: flex;
        gap: 10px;
      }
      
      .btn-delete {
        padding: 8px 16px;
        background: #e74c3c;
        color: white;
        border: none;
        border-radius: 6px;
        font-size: 0.9rem;
        cursor: pointer;
        transition: background 0.3s;
      }
      
      .btn-delete:hover {
        background: #c0392b;
      }
      
      .empty-state {
        text-align: center;
        padding: 60px 20px;
        color: #999;
      }
      
      .empty-state svg {
        width: 100px;
        height: 100px;
        margin-bottom: 20px;
        opacity: 0.3;
      }
      
      @media (max-width: 600px) {
        .container {
          padding: 20px;
        }
        
        h1 {
          font-size: 2rem;
        }
        
        .input-container {
          flex-direction: column;
        }
        
        button {
          width: 100%%;
        }
        
        .todo-item {
          padding: 15px;
        }
        
        .todo-text {
          font-size: 1rem;
        }
      }
    </style>
  </head>
  <body>
    <div class="container">
      <h1>✨ Todo App</h1>
      
      <form method="POST" action="/api/todos" class="input-container">
        <%s! Dream.csrf_tag request %>
        <input type="text" name="title" placeholder="What needs to be done?" required autofocus>
        <button type="submit">Add</button>
      </form>
      
      <ul class="todo-list" id="todoList">
        <!-- Todos will be loaded here -->
      </ul>
      
      <div class="empty-state" id="emptyState" style="display: none;">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M9 11l3 3L22 4"></path>
          <path d="M21 12v7a2 2 0 01-2 2H5a2 2 0 01-2-2V5a2 2 0 012-2h11"></path>
        </svg>
        <p>No todos yet. Add one above!</p>
      </div>
    </div>
    
    <script>
      async function loadTodos() {
        const response = await fetch('/api/todos');
        const todos = await response.json();
        const todoList = document.getElementById('todoList');
        const emptyState = document.getElementById('emptyState');
        
        if (todos.length === 0) {
          todoList.style.display = 'none';
          emptyState.style.display = 'block';
        } else {
          todoList.style.display = 'block';
          emptyState.style.display = 'none';
          
          todoList.innerHTML = todos.map(todo => `
            <li class="todo-item ${todo.completed ? 'completed' : ''}">
              <input type="checkbox" class="todo-checkbox" 
                     ${todo.completed ? 'checked' : ''} 
                     onchange="toggleTodo(${todo.id})">
              <span class="todo-text">${escapeHtml(todo.title)}</span>
              <div class="todo-actions">
                <button class="btn-delete" onclick="deleteTodo(${todo.id})">Delete</button>
              </div>
            </li>
          `).join('');
        }
      }
      
      async function toggleTodo(id) {
        await fetch(`/api/todos/${id}/toggle`, { method: 'POST' });
        loadTodos();
      }
      
      async function deleteTodo(id) {
        if (confirm('Are you sure you want to delete this todo?')) {
          await fetch(`/api/todos/${id}`, { method: 'DELETE' });
          loadTodos();
        }
      }
      
      function escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
      }
      
      // Load todos on page load
      loadTodos();
      
      // Reload after form submission
      document.querySelector('form').addEventListener('submit', async (e) => {
        e.preventDefault();
        const formData = new FormData(e.target);
        await fetch('/api/todos', {
          method: 'POST',
          body: formData
        });
        e.target.reset();
        loadTodos();
      });
    </script>
  </body>
  </html>

let successful = ref 0
let failed = ref 0
let count_requests inner_handler request = 
  try%lwt
    let%lwt response = inner_handler request in
    successful := !successful + 1;
    Lwt.return response
  with exn ->
    failed := !failed + 1;
    raise exn

let my_error_template _error debug_info suggested_response =
  let status = Dream.status suggested_response in
  let code = Dream.status_to_int status and reason = Dream.status_to_string status in
  Dream.set_header suggested_response "Content-Type" Dream.text_html;
  Dream.set_body suggested_response begin
    <html>
      <body>
        <h1><%i code %> <%s reason %></h1>
        <pre><%s debug_info %></pre>
      </body>
    </html>
  end;
  Lwt.return suggested_response

let () =
  Dream.run
    ~error_handler:(Dream.error_template my_error_template)
  @@ Dream.logger
  @@ Dream.sql_pool "sqlite3:db.sqlite"
  @@ Dream.sql_sessions
  @@ Dream.origin_referrer_check
  @@ Dream.memory_sessions
  @@ count_requests
  @@ Dream.router [
    (* Todo App UI *)
    Dream.get "/" (fun request -> Dream.html (render_todo_app request));
    
    (* Todo API endpoints *)
    Dream.get "/api/todos" (fun request ->
        let%lwt todos = Dream.sql request list_todos in
        let json = `List (List.map (fun t -> todo_to_yojson t) todos) in
        Dream.json (Yojson.Safe.to_string json));
    
    Dream.post "/api/todos" (fun request ->
        match%lwt Dream.form request with
        | `Ok ["title", title] when String.trim title <> "" ->
            let%lwt () = Dream.sql request (add_todo (String.trim title)) in
            Dream.redirect request "/"
        | _ -> Dream.empty `Bad_Request);
    
    Dream.get "/api/todos/:id" (fun request ->
        let id = Dream.param request "id" |> int_of_string in
        let%lwt todo_opt = Dream.sql request (get_todo id) in
        match todo_opt with
        | Some todo -> todo |> todo_to_yojson |> Yojson.Safe.to_string |> Dream.json
        | None -> Dream.empty `Not_Found);
    
    Dream.post "/api/todos/:id/toggle" (fun request ->
        let id = Dream.param request "id" |> int_of_string in
        let%lwt () = Dream.sql request (toggle_todo id) in
        Dream.json "{}");
    
    Dream.delete "/api/todos/:id" (fun request ->
        let id = Dream.param request "id" |> int_of_string in
        let%lwt () = Dream.sql request (delete_todo id) in
        Dream.json "{}");
    
    (* Static files *)
    Dream.get "/static/**" (Dream.static "./public");
  ]
