(* Application Layer - Use cases *)

open Domain

module AddressService (R : REPOSITORY) = struct
  let create_address input db =
    R.create input db

  let get_address id db =
    R.read id db

  let get_all_addresses db =
    R.read_all db

  let update_address id input db =
    R.update id input db

  let delete_address id db =
    R.delete id db
end
