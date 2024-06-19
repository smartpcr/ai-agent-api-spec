import "@typespec/http";
import "@typespec/rest";
import "@typespec/openapi3";
import "@typespec/versioning";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;

@service({title: "AI Agent", description: "AI Agent service"})
@server("http://localhost:8080", "endpoint for ai agent service")
@versioned(Versions)
namespace AI;

enum Versions {
  v1,
}

model IdName {
  @doc("The unique identifier for the resource")
  @minValue(0)
  id: int32;
  @doc("The name of the resource")
  @minLength(5)
  @maxLength(100)
  name: string;
}

op ListResource<T>(): T[];
op GetResourceById<T>(@path id: int32): T;

interface CRUD<T> {
  op list is ListResource<T>;
  op getById is GetResourceById<T>;
  @put op update(@path id: int32, resource: T): T;
  @post op create(@path id: int32, resource: T): T;
  @delete op delete(@path id: int32): void;
}

@route("/agents")
namespace AI.Agents {
  model Agent extends IdName {
    @doc("The description of the agent")
    @maxLength(1000)
    description?: string;
    @doc("The type of the agent")
    @maxLength(255)
    type: string;
    @doc("The status of the agent")
    status?: AgentStatus;
  }

  enum AgentStatus {
    active,
    inactive,
  }

  interface agent_operation extends CRUD<Agent> {}
}

@route("/users")
namespace AI.Users {
  model User extends IdName {}

  interface user_operation extends CRUD<User> {}
}
