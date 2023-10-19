defmodule LiveViewNative.SwiftUI.RulesParser do
  use LiveViewNative.Stylesheet.RulesParser, :swiftui
  alias LiveViewNative.SwiftUI.RulesParser.Modifiers

  defmacro __using__(_) do
    quote do
      import LiveViewNative.SwiftUI.RulesParser, only: [sigil_RULES: 2]
      import LiveViewNative.SwiftUI.RulesHelpers
    end
  end

  def parse(rules, opts \\ []) do
    case Modifiers.modifiers(rules, opts) do
      {:ok, [output], _unconsumed = "", _context, _current_line_and_offset, _} ->
        output

      {:ok, output, _unconsumed = "", _context, _current_line_and_offset, _} ->
        output

      {:error, message, _unconsumed, _context, {line, column}, _} ->
        # TODO: Improve errors:
        # - Point to column with error in source rules
        throw(
          SyntaxError.message(%{
            file: "Rules",
            line: line,
            column: column,
            description: message
          })
        )
    end
  end
end