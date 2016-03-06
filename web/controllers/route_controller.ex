defmodule Oiseau.RouteController do
  use Oiseau.Web, :controller
  alias Neo4j.Sips, as: Neo4j

  def do_the_magic(conn, params) do
    cypher = """
      MATCH (from: Node  {shape_pt_sequence: 0}), (to: Node {shape_pt_sequence: 25}) , 
        paths = allShortestPaths((from)-[*]->(to))
      WITH REDUCE(dist = 0, rel in rels(paths) | dist + rel.distance) AS distance, paths
      RETURN paths, distance
      ORDER BY distance
      LIMIT 1
    """
   [result] = Neo4j.query!(Neo4j.conn, cypher)
   json(conn, %{id: result["id"]})
  end
end