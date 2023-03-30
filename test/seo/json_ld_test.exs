defmodule SEO.JSONLDTest do
  use ExUnit.Case, async: true
  import Phoenix.LiveViewTest
  alias SEO.JSONLD

  describe "meta" do
    test "renders one JSON-LD" do
      config = %{}

      item = %{
        "@context" => "https://schema.org",
        "@type" => "WebSite",
        "url" => "https://www.example.com/",
        "potentialAction" => %{
          "@type" => "SearchAction",
          "target" => %{
            "@type" => "EntryPoint",
            "urlTemplate" => "https://query.example.com/search?q={search_term_string}"
          },
          "query-input" => "required name=search_term_string"
        }
      }

      result = render_component(&JSONLD.meta/1, build_assigns(item, config))

      assert result ==
               "<script type=\"application/ld+json\">\n  {\"@context\":\"https://schema.org\",\"@type\":\"WebSite\",\"potentialAction\":{\"@type\":\"SearchAction\",\"query-input\":\"required name=search_term_string\",\"target\":{\"@type\":\"EntryPoint\",\"urlTemplate\":\"https://query.example.com/search?q={search_term_string}\"}},\"url\":\"https://www.example.com/\"}\n</script>"
    end

    test "renders many JSON-LD" do
      config = %{}

      item = [
        %{
          "@context" => "http://schema.org",
          "@type" => "FAQPage",
          "headline" => "3 Ways to Be Nice - wikiHow",
          "name" => "3 Ways to Be Nice - wikiHow",
          "mainEntity" => [
            %{
              "@type" => "Question",
              "name" => "Do girls like nice guys?",
              "acceptedAnswer" => %{
                "@type" => "Answer",
                "text" =>
                  "Always be kind. If you like someone, tell them what you like about them, and don't focus on just their looks. Compliment them in a way that makes them feel seen. Tell them that you really like how passionate they are about their work, for example, or anything that relates to your shared interests."
              }
            }
          ]
        },
        %{
          "@context" => "http://schema.org",
          "@type" => "Article",
          "headline" => "3 Ways to Be Nice - wikiHow",
          "name" => "3 Ways to Be Nice - wikiHow",
          "mainEntityOfPage" => %{
            "@type" => "WebPage",
            "id" => "https://www.wikihow.com/Be-Nice"
          },
          "image" => %{
            "@type" => "ImageObject",
            "url" =>
              "https://www.wikihow.com/images/thumb/2/26/Be-Nice-Step-18.jpg/aid10053-v4-1200px-Be-Nice-Step-18.jpg",
            "width" => 1200,
            "height" => 900
          },
          "author" => %{
            "@type" => "Person",
            "name" => "Kelli Miller, LCSW, MSW",
            "sameAs" => [
              "https://www.kellimillertherapy.com/",
              "https://www.linkedin.com/in/kellimillermsw/",
              "https://www.facebook.com/kellimillertherapy"
            ]
          },
          "datePublished" => "2005-09-30",
          "dateModified" => "2023-03-13",
          "description" =>
            "Being nice makes people feel good and paves the way for good relationships!"
        }
      ]

      result = render_component(&JSONLD.meta/1, build_assigns(item, config))

      assert result ==
               "<script type=\"application/ld+json\">\n  {\"@context\":\"http://schema.org\",\"@type\":\"FAQPage\",\"headline\":\"3 Ways to Be Nice - wikiHow\",\"mainEntity\":[{\"@type\":\"Question\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Always be kind. If you like someone, tell them what you like about them, and don't focus on just their looks. Compliment them in a way that makes them feel seen. Tell them that you really like how passionate they are about their work, for example, or anything that relates to your shared interests.\"},\"name\":\"Do girls like nice guys?\"}],\"name\":\"3 Ways to Be Nice - wikiHow\"}\n</script><script type=\"application/ld+json\">\n  {\"@context\":\"http://schema.org\",\"@type\":\"Article\",\"author\":{\"@type\":\"Person\",\"name\":\"Kelli Miller, LCSW, MSW\",\"sameAs\":[\"https://www.kellimillertherapy.com/\",\"https://www.linkedin.com/in/kellimillermsw/\",\"https://www.facebook.com/kellimillertherapy\"]},\"dateModified\":\"2023-03-13\",\"datePublished\":\"2005-09-30\",\"description\":\"Being nice makes people feel good and paves the way for good relationships!\",\"headline\":\"3 Ways to Be Nice - wikiHow\",\"image\":{\"@type\":\"ImageObject\",\"height\":900,\"url\":\"https://www.wikihow.com/images/thumb/2/26/Be-Nice-Step-18.jpg/aid10053-v4-1200px-Be-Nice-Step-18.jpg\",\"width\":1200},\"mainEntityOfPage\":{\"@type\":\"WebPage\",\"id\":\"https://www.wikihow.com/Be-Nice\"},\"name\":\"3 Ways to Be Nice - wikiHow\"}\n</script>"
    end

    test "doesn't render when list is empty or nil" do
      config = %{}

      item = []
      result = render_component(&JSONLD.meta/1, build_assigns(item, config))
      assert result == ""

      item = nil
      result = render_component(&JSONLD.meta/1, build_assigns(item, config))
      assert result == ""

      item = %{}
      result = render_component(&JSONLD.meta/1, build_assigns(item, config))
      assert result == ""

      item = [%{}, %{}]
      result = render_component(&JSONLD.meta/1, build_assigns(item, config))
      assert result == ""

      item = [[], []]
      result = render_component(&JSONLD.meta/1, build_assigns(item, config))
      assert result == ""
    end
  end

  defp build_assigns(item, config) do
    [item: item, config: config, json_library: Jason]
  end
end
