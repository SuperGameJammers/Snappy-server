defmodule Oiseau.RouteController do
  use Oiseau.Web, :controller
  alias Neo4j.Sips, as: Neo4j
  use HTTPoison.Base

  def do_the_magic(conn, params) do
    elastic_query = %{"query" => %{"filtered" => %{"query" => 
                          %{"match_all" => %{}}, "filter" => 
                               %{"geo_distance" => 
                              %{"distance" => "1000km", "location" => 
                                %{"lat" => 18.9534143986, "lon" => -99.5033692569}}}}}}

    case post("http://localhost:9200/nodes/_search", elastic_query) do
      {:ok, %HTTPoison.Response{body: %{"hits" => %{"hits" => geo_points}}}} ->

        %{"_source" => %{"id" => origin}} = Enum.at(geo_points, 0)
        %{"_source" => %{"id" => destiny}} = Enum.at(geo_points, (Enum.count(geo_points) - 1))
        
        cypher = """
          MATCH (from: Node  {shape_pt_sequence: #{origin}}), (to: Node {shape_pt_sequence: #{destiny}}) , 
            paths = allShortestPaths((from)-[*]->(to))
          WITH REDUCE(dist = 0, rel in rels(paths) | dist + rel.distance) AS distance, paths
          RETURN paths, distance
          ORDER BY distance
          LIMIT 1
        """
        [result] = Neo4j.query!(Neo4j.conn, cypher)
        json(conn, %{result: result})
       {:error, reason} ->
        json(conn, %{error: "Falló elasticsearch #{reason}"})
    end
    
  end



  def process_url(url) do
    url
  end

  def process_request_headers(headers) do
    headers
    |> Dict.put(:"Content-Type", "application/json; charset=UTF-8")
  end

  def process_request_body(body) do
    Poison.encode!(body)
  end

  def process_response_body(body) do
    case body |> to_string |> Poison.decode do
      {:error, _} -> body
      {:ok, decoded} -> decoded
    end
  end

  def response({x, response}), do: {x, response.body}
end