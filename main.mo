//***importlar***

import Map "mo:base/HashMap";
import Hash "mo:base/Hash";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Text "mo:base/Text";

//smart contract actor keyi ile oluşturuluyor.
//***smart contract => canister (icp)***

actor Assistant {
  type ToDo = {
    description : Text;
    completed : Bool;
  };

  //Basit data türleri
  //text => string
  //boolean => true, false
  //Nat => natural number (integer)

  //***fonksiyonlar***
  func natHash(n : Nat) : Hash.Hash {
    Text.hash(Nat.toText(n));
  };

  //***değişkenler***
  //let=> immutable
  //var=> mutable
  //const => global

  var todos = Map.HashMap<Nat, ToDo>(0, Nat.equal, natHash);
  var nextId : Nat = 0;

  //func => private
  //public query func => sorgulama
  //public func => update

  public query func getTodos() : async [ToDo] {
    Iter.toArray(todos.vals());
  };

  public func addTodo(description : Text) : async Nat {
    let id = nextId;
    todos.put(id, { description = description; completed = false });
    nextId += 1;
    return id;
    id;
  };

  public func completeTodo(id : Nat) : async () {
    ignore do ? {
      let description = todos.get(id)!.description;
      todos.put(id, { description; completed = true });
    };
  };

  public query func showTodos() : async Text {
    var output : Text = "\n________ TO-DOS________";
    for (todo : ToDo in todos.vals()) {
      output #= "\n" # todo.description;
      if (todo.completed) { output #= " !" };
    };
    output # "\n";
  };

  public func clearCompleted() : async () {
    todos := Map.mapFilter<Nat, ToDo, ToDo>(
      todos,
      Nat.equal,
      natHash,
      func(_, todo) { if (todo.completed) null else ?todo },
    );
  };

};
