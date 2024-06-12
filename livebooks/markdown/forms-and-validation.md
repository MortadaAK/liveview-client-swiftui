# Forms and Validation

[![Run in Livebook](https://livebook.dev/badge/v1/blue.svg)](https://livebook.dev/run?url=https%3A%2F%2Fraw.githubusercontent.com%2Fliveview-native%liveview-client-swiftui%2Fmain%2Flivebooks%forms-and-validation.livemd)

## Overview

The [LiveView Native Live Form](https://github.com/liveview-native/liveview-native-live-form) project makes it easier to build forms in LiveView Native. This project enables you to group different [Control Views](https://developer.apple.com/documentation/swiftui/controls-and-indicators) inside of a `LiveForm` and control them collectively under a single `phx-change` or `phx-submit` event handler, rather than with multiple different `phx-change` event handlers.

Getting the most out of this material requires some understanding of the [Ecto](https://hexdocs.pm/ecto/Ecto.html) project and in particular a reasonably deep understanding of [Ecto.Changeset](https://hexdocs.pm/ecto/Ecto.Changeset.html). Review the Ecto documentation if you find any of the examples difficult to follow.

## Creating a Basic Form

The LiveView Native `mix lvn.install` task generates a [core_components.swiftui.ex](https://github.com/liveview-native/liveview-client-swiftui/blob/main/priv/templates/lvn.swiftui.gen/core_components.ex) file for native SwiftUI function components similar to the [core_components.ex](https://github.com/phoenixframework/phoenix/blob/main/priv/templates/phx.gen.live/core_components.ex) file generated in a traditional phoenix application for web function components.

See Phoenix's [Components and HEEx](https://hexdocs.pm/phoenix/components.html) HexDoc documentation if you need a primer on function components.

In the `core_components.swiftui.ex` file there's a `simple_form/1` component that is a similar abstraction to the `simple_form/1` component found in `core_components.ex`.

First, we'll see how to use this abstraction at a basic level, then later we'll dive deeper into how forms work under the hood in LiveView Native.



### A Basic Form

The code below demonstrates a basic form that uses the same event handlers for the `phx-change` and `phx-submit` events on both the web and native versions of the form. 

We'll break down and understand the individual parts of this form in a moment.

For now, evaluate the following example. Open the native form in your simulator, and open the web form on http://localhost:4000/. Enter some text into both forms, then submit them. Watch the logs in the cell below to see the printed params.

<!-- livebook:{"attrs":"eyJjb2RlIjoiZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZS5Td2lmdFVJIGRvXG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIFs6cmVuZGVyX2NvbXBvbmVudCwgZm9ybWF0OiA6c3dpZnR1aV1cblxuICBkZWYgcmVuZGVyKGFzc2lnbnMpIGRvXG4gICAgfkxWTlwiXCJcIlxuICAgIDwuc2ltcGxlX2Zvcm0gZm9yPXtAZm9ybX0gaWQ9XCJmb3JtXCIgcGh4LXN1Ym1pdD1cInN1Ym1pdFwiIHBoeC1jaGFuZ2U9XCJ2YWxpZGF0ZVwiPlxuICAgICAgPC5pbnB1dCBmaWVsZD17QGZvcm1bOnZhbHVlXX0gdHlwZT1cIlRleHRGaWVsZFwiIHBsYWNlaG9sZGVyPVwiRW50ZXIgYSB2YWx1ZVwiIC8+XG4gICAgICA8OmFjdGlvbnM+XG4gICAgICAgIDwuYnV0dG9uIHR5cGU9XCJzdWJtaXRcIj5cbiAgICAgICAgICBQaW5nXG4gICAgICAgIDwvLmJ1dHRvbj5cbiAgICAgIDwvOmFjdGlvbnM+XG4gICAgPC8uc2ltcGxlX2Zvcm0+XG4gICAgXCJcIlwiXG4gIGVuZFxuZW5kXG5cbmRlZm1vZHVsZSBTZXJ2ZXJXZWIuRXhhbXBsZUxpdmUgZG9cbiAgdXNlIFNlcnZlcldlYiwgOmxpdmVfdmlld1xuICB1c2UgU2VydmVyTmF0aXZlLCA6bGl2ZV92aWV3XG5cbiAgQGltcGwgdHJ1ZVxuICBkZWYgbW91bnQoX3BhcmFtcywgX3Nlc3Npb24sIHNvY2tldCkgZG9cbiAgICB7Om9rLCBhc3NpZ24oc29ja2V0LCBmb3JtOiB0b19mb3JtKCV7fSwgYXM6IFwibXlfZm9ybVwiKSl9XG4gIGVuZFxuXG4gIEBpbXBsIHRydWVcbiAgZGVmIHJlbmRlcihhc3NpZ25zKSBkb1xuICAgIH5IXCJcIlwiXG4gICAgICA8LnNpbXBsZV9mb3JtIGZvcj17QGZvcm19IGlkPVwiZm9ybVwiIHBoeC1zdWJtaXQ9XCJzdWJtaXRcIiBwaHgtY2hhbmdlPVwidmFsaWRhdGVcIj5cbiAgICAgIDwuaW5wdXQgZmllbGQ9e0Bmb3JtWzp2YWx1ZV19IHBsYWNlaG9sZGVyPVwiRW50ZXIgYSB2YWx1ZVwiIC8+XG4gICAgICA8OmFjdGlvbnM+XG4gICAgICAgIDwuYnV0dG9uIHR5cGU9XCJzdWJtaXRcIj5cbiAgICAgICAgICBQaW5nXG4gICAgICAgIDwvLmJ1dHRvbj5cbiAgICAgIDwvOmFjdGlvbnM+XG4gICAgPC8uc2ltcGxlX2Zvcm0+XG4gICAgXCJcIlwiXG4gIGVuZFxuXG4gIEBpbXBsIHRydWVcbiAgZGVmIGhhbmRsZV9ldmVudChcInN1Ym1pdFwiLCBwYXJhbXMsIHNvY2tldCkgZG9cbiAgICBJTy5pbnNwZWN0KHBhcmFtcywgbGFiZWw6IFwiU3VibWl0dGVkXCIpXG4gICAgezpub3JlcGx5LCBzb2NrZXR9XG4gIGVuZFxuXG4gIEBpbXBsIHRydWVcbiAgZGVmIGhhbmRsZV9ldmVudChcInZhbGlkYXRlXCIsIHBhcmFtcywgc29ja2V0KSBkb1xuICAgIElPLmluc3BlY3QocGFyYW1zLGxhYmVsOiBcIlZhbGlkYXRpbmdcIilcbiAgICB7Om5vcmVwbHksIHNvY2tldH1cbiAgZW5kXG5lbmQiLCJwYXRoIjoiLyJ9","chunks":[[0,85],[87,1272],[1361,49],[1412,51]],"kind":"Elixir.Server.SmartCells.LiveViewNative","livebook_object":"smart_cell"} -->

```elixir
defmodule ServerWeb.ExampleLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assigns) do
    ~LVN"""
    <.simple_form for={@form} id="form" phx-submit="submit" phx-change="validate">
      <.input field={@form[:value]} type="TextField" placeholder="Enter a value" />
      <:actions>
        <.button type="submit">
          Ping
        </.button>
      </:actions>
    </.simple_form>
    """
  end
end

defmodule ServerWeb.ExampleLive do
  use ServerWeb, :live_view
  use ServerNative, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}, as: "my_form"))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.simple_form for={@form} id="form" phx-submit="submit" phx-change="validate">
      <.input field={@form[:value]} placeholder="Enter a value" />
      <:actions>
        <.button type="submit">
          Ping
        </.button>
      </:actions>
    </.simple_form>
    """
  end

  @impl true
  def handle_event("submit", params, socket) do
    IO.inspect(params, label: "Submitted")
    {:noreply, socket}
  end

  @impl true
  def handle_event("validate", params, socket) do
    IO.inspect(params, label: "Validating")
    {:noreply, socket}
  end
end
```

After submitting both forms, notice that both the web and native params are the same shape:`%{"my_form" => %{"value" => "some text"}}`. This makes it easier to share event handlers for both web and native.

Sharing event handlers hugely simplifies and speeds up the process of writing web and native application logic because you only have to write the logic once. Alternatively, if your web and native UI deviates significantly, you can also separate the event handlers.

## Breaking down a Basic Form

### Simple Form

The interface for the native `simple_form/1` and web `simple_form/1` is intentionally identical.

```heex
<.simple_form for={@form} id="form" phx-submit="submit">
<!-- Inputs and Submit Button goes here -->
</.simple_form>
```

We'll go into the internal implementation details later on, but for now you can treat these components as functionally identical. Both require a unique `id` and accept the `for` attribute that contains the [Phoenix.HTML.Form](https://hexdocs.pm/phoenix_html/Phoenix.HTML.Form.html) datastructure containing form fields, error messages, and other form data.

If you need a refresher on forms in Phoenix, see the [Form Bindings](https://hexdocs.pm/phoenix_live_view/form-bindings.html) HexDoc documentation.



### Inputs

Both web and native core components define a `input/1` function component. Inputs in the web form and native form differ since one is an abstraction on top of HTML elements and the other is an abstraction on top of SwiftUI Views. Therefore, they have different values for the `type` attribte that determines which input type to render.

On web, the `input/1` component accepts the following values for the `type` attribute. These reflect [html input types](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input#input_types).

<!-- livebook:{"force_markdown":true} -->

```elixir
  attr :type, :string,
    default: "text",
    values: ~w(checkbox color date datetime-local email file hidden month number password
               range radio search select tel text textarea time url week)
```

On native, the `input/1` component accepts the following values for the `type` attribute. These reflect the SwiftUI Views from the [Controls and Indicators](https://developer.apple.com/documentation/swiftui/controls-and-indicators) and [Text Input and Outputs](https://developer.apple.com/documentation/swiftui/text-input-and-output) sections.

<!-- livebook:{"force_markdown":true} -->

```elixir
attr :type, :string,
  default: "TextField",
  values: ~w(TextFieldLink DatePicker MultiDatePicker Picker SecureField Slider Stepper TextEditor TextField Toggle hidden)
```

## Changesets

The [Phoenix.Component.to_form/2](https://hexdocs.pm/phoenix_live_view/Phoenix.Component.html#to_form/2) function also supports Ecto changesets for form data and error validation. See [Ecto.Changeset](https://hexdocs.pm/ecto/Ecto.Changeset.html) for a refresher on changesets. Also see [Form Bindings](https://hexdocs.pm/phoenix_live_view/form-bindings.html) and [Phoenix.HTML.Form](https://hexdocs.pm/phoenix_html/Phoenix.HTML.Form.html) for a refresher on Phoenix Forms.

We'll use the following changeset to demonstrate how to validate data in a LiveView Native Live Form.

```elixir
defmodule User do
  import Ecto.Changeset
  defstruct [:email]
  @types %{email: :string}

  def changeset(user, params) do
    {user, @types}
    |> cast(params, [:email])
    |> validate_required([:email])
    |> validate_format(:email, ~r/@/)
  end
end
```

The [Phoenix.HTML.Form](https://hexdocs.pm/phoenix_html/Phoenix.HTML.Form.html) struct stores the changeset. The `simple_form/1` and `input/1` components for both web and native use the [Phoenix.HTML.Form](https://hexdocs.pm/phoenix_html/Phoenix.HTML.Form.html) struct and nested [Phoenix.HTML.FormField](https://hexdocs.pm/phoenix_html/Phoenix.HTML.FormField.html) structs to render form data and display errors.

For example, `:action` field in the changeset determines if errors should display or not. Here's an example we'll use in a moment of faking a database `:insert` action and storing the changeset information inside of a form.

```elixir
User.changeset(%User{}, %{email: "test"})
|> Map.put(:action, :insert)
|> Phoenix.Component.to_form()
```

Here's an example of how we can use Ecto changesets with the LiveView Native Live Form. Now when we submit or validate the form data we apply the changes to the changeset and store the new version of the form in the socket. The `simple_form/1` and `input/1` components use the form data to render content and display errors.

Evaluate the cell below and open your iOS application. Submit the form with an invalid email. You should notice a `has invalid format` error appear.

<!-- livebook:{"attrs":"eyJjb2RlIjoiZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZS5Td2lmdFVJIGRvXG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIFs6cmVuZGVyX2NvbXBvbmVudCwgZm9ybWF0OiA6c3dpZnR1aV1cblxuICBkZWYgcmVuZGVyKGFzc2lnbnMpIGRvXG4gICAgfkxWTlwiXCJcIlxuICAgIDwuc2ltcGxlX2Zvcm0gZm9yPXtAZm9ybX0gaWQ9XCJmb3JtXCIgcGh4LXN1Ym1pdD1cInN1Ym1pdFwiIHBoeC1jaGFuZ2U9XCJ2YWxpZGF0ZVwiPlxuICAgICAgPC5pbnB1dCBmaWVsZD17QGZvcm1bOmVtYWlsXX0gdHlwZT1cIlRleHRGaWVsZFwiIHBsYWNlaG9sZGVyPVwiRW1haWxcIiAvPlxuICAgICAgPDphY3Rpb25zPlxuICAgICAgICA8LmJ1dHRvbiB0eXBlPVwic3VibWl0XCI+XG4gICAgICAgICAgU3VibWl0XG4gICAgICAgIDwvLmJ1dHRvbj5cbiAgICAgIDwvOmFjdGlvbnM+XG4gICAgPC8uc2ltcGxlX2Zvcm0+XG4gICAgXCJcIlwiXG4gIGVuZFxuZW5kXG5cbmRlZm1vZHVsZSBTZXJ2ZXJXZWIuRXhhbXBsZUxpdmUgZG9cbiAgdXNlIFNlcnZlcldlYiwgOmxpdmVfdmlld1xuICB1c2UgU2VydmVyTmF0aXZlLCA6bGl2ZV92aWV3XG5cbiAgQGltcGwgdHJ1ZVxuICBkZWYgbW91bnQoX3BhcmFtcywgX3Nlc3Npb24sIHNvY2tldCkgZG9cbiAgICBjaGFuZ2VzZXQgPSBVc2VyLmNoYW5nZXNldCglVXNlcnt9LCAle30pXG4gICAgezpvaywgYXNzaWduKHNvY2tldCwgZm9ybTogdG9fZm9ybShjaGFuZ2VzZXQpKX1cbiAgZW5kXG5cbiAgQGltcGwgdHJ1ZVxuICBkZWYgcmVuZGVyKGFzc2lnbnMpIGRvXG4gICAgfkhcIlwiXCJcbiAgICA8LnNpbXBsZV9mb3JtIGZvcj17QGZvcm19IGlkPVwiZm9ybVwiIHBoeC1zdWJtaXQ9XCJzdWJtaXRcIiBwaHgtY2hhbmdlPVwidmFsaWRhdGVcIj5cbiAgICAgIDwuaW5wdXQgZmllbGQ9e0Bmb3JtWzplbWFpbF19IHBsYWNlaG9sZGVyPVwiRW1haWxcIiAvPlxuICAgICAgPDphY3Rpb25zPlxuICAgICAgICA8LmJ1dHRvbiB0eXBlPVwic3VibWl0XCI+XG4gICAgICAgICAgU3VibWl0XG4gICAgICAgIDwvLmJ1dHRvbj5cbiAgICAgIDwvOmFjdGlvbnM+XG4gICAgPC8uc2ltcGxlX2Zvcm0+XG4gICAgXCJcIlwiXG4gIGVuZFxuXG4gIEBpbXBsIHRydWVcbiAgZGVmIGhhbmRsZV9ldmVudChcInN1Ym1pdFwiLCAle1widXNlclwiID0+IHBhcmFtc30sIHNvY2tldCkgZG9cbiAgICBjaGFuZ2VzZXQgPVxuICAgICAgVXNlci5jaGFuZ2VzZXQoJVVzZXJ7fSwgcGFyYW1zKVxuICAgICAgIyBGYWtpbmcgYSBEYXRhYmFzZSBpbnNlcnQgYWN0aW9uXG4gICAgICB8PiBNYXAucHV0KDphY3Rpb24sIDppbnNlcnQpXG4gICAgICB8PiBJTy5pbnNwZWN0KGxhYmVsOiBcIkZvcm0gRmllbGQgVmFsdWVzXCIpXG5cbiAgICB7Om5vcmVwbHksIGFzc2lnbihzb2NrZXQsIGZvcm06IHRvX2Zvcm0oY2hhbmdlc2V0KSl9XG4gIGVuZFxuXG4gIEBpbXBsIHRydWVcbiAgZGVmIGhhbmRsZV9ldmVudChcInZhbGlkYXRlXCIsICV7XCJ1c2VyXCIgPT4gcGFyYW1zfSwgc29ja2V0KSBkb1xuICAgIGNoYW5nZXNldCA9XG4gICAgICBVc2VyLmNoYW5nZXNldCglVXNlcnt9LCBwYXJhbXMpXG4gICAgICB8PiBNYXAucHV0KDphY3Rpb24sIDp2YWxpZGF0ZSlcblxuICAgIHs6bm9yZXBseSwgYXNzaWduKHNvY2tldCwgZm9ybTogdG9fZm9ybShjaGFuZ2VzZXQpKX1cbiAgZW5kXG5lbmQiLCJwYXRoIjoiLyJ9","chunks":[[0,85],[87,1572],[1661,49],[1712,51]],"kind":"Elixir.Server.SmartCells.LiveViewNative","livebook_object":"smart_cell"} -->

```elixir
defmodule ServerWeb.ExampleLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assigns) do
    ~LVN"""
    <.simple_form for={@form} id="form" phx-submit="submit" phx-change="validate">
      <.input field={@form[:email]} type="TextField" placeholder="Email" />
      <:actions>
        <.button type="submit">
          Submit
        </.button>
      </:actions>
    </.simple_form>
    """
  end
end

defmodule ServerWeb.ExampleLive do
  use ServerWeb, :live_view
  use ServerNative, :live_view

  @impl true
  def mount(_params, _session, socket) do
    changeset = User.changeset(%User{}, %{})
    {:ok, assign(socket, form: to_form(changeset))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.simple_form for={@form} id="form" phx-submit="submit" phx-change="validate">
      <.input field={@form[:email]} placeholder="Email" />
      <:actions>
        <.button type="submit">
          Submit
        </.button>
      </:actions>
    </.simple_form>
    """
  end

  @impl true
  def handle_event("submit", %{"user" => params}, socket) do
    changeset =
      User.changeset(%User{}, params)
      # Faking a Database insert action
      |> Map.put(:action, :insert)
      |> IO.inspect(label: "Form Field Values")

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  @impl true
  def handle_event("validate", %{"user" => params}, socket) do
    changeset =
      User.changeset(%User{}, params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(changeset))}
  end
end
```

## Keyboard Types

The [keyboardType](https://developer.apple.com/documentation/swiftui/view/keyboardtype(_:)) modifier changes the type of keyboard for a TextField view.

Evaluate the example below to see the different keyboards as you focus on each input. If you don't see the keyboard, go to `I/O` -> `Keyboard` -> `Toggle Software Keyboard` to enable the software keyboard in your simulator.

<!-- livebook:{"attrs":"eyJjb2RlIjoiZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZS5Td2lmdFVJIGRvXG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIFs6cmVuZGVyX2NvbXBvbmVudCwgZm9ybWF0OiA6c3dpZnR1aV1cblxuICBkZWYgcmVuZGVyKGFzc2lnbnMpIGRvXG4gICAgfkxWTlwiXCJcIlxuICAgIDwuc2ltcGxlX2Zvcm0gZm9yPXtAZm9ybX0gaWQ9XCJmb3JtXCI+XG4gICAgICA8LmlucHV0IGZpZWxkPXtAZm9ybVs6bnVtYmVyX3BhZF19IHR5cGU9XCJUZXh0RmllbGRcIiBzdHlsZT1cImtleWJvYXJkVHlwZSgubnVtYmVyUGFkKVwiLz5cbiAgICAgIDwuaW5wdXQgZmllbGQ9e0Bmb3JtWzplbWFpbF9hZGRyZXNzXX0gdHlwZT1cIlRleHRGaWVsZFwiIHN0eWxlPVwia2V5Ym9hcmRUeXBlKC5lbWFpbEFkZHJlc3MpXCIvPlxuICAgICAgPC5pbnB1dCBmaWVsZD17QGZvcm1bOnBob25lUGFkXX0gdHlwZT1cIlRleHRGaWVsZFwiIHN0eWxlPVwia2V5Ym9hcmRUeXBlKC5waG9uZVBhZClcIi8+XG4gICAgICA8OmFjdGlvbnM+XG4gICAgICAgIDwuYnV0dG9uIHR5cGU9XCJzdWJtaXRcIj5cbiAgICAgICAgICBTdWJtaXRcbiAgICAgICAgPC8uYnV0dG9uPlxuICAgICAgPC86YWN0aW9ucz5cbiAgICA8Ly5zaW1wbGVfZm9ybT5cbiAgICBcIlwiXCJcbiAgZW5kXG5lbmQifQ","chunks":[[0,85],[87,602],[691,47],[740,51]],"kind":"Elixir.Server.SmartCells.RenderComponent","livebook_object":"smart_cell"} -->

```elixir
defmodule ServerWeb.ExampleLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assigns) do
    ~LVN"""
    <.simple_form for={@form} id="form">
      <.input field={@form[:number_pad]} type="TextField" style="keyboardType(.numberPad)"/>
      <.input field={@form[:email_address]} type="TextField" style="keyboardType(.emailAddress)"/>
      <.input field={@form[:phonePad]} type="TextField" style="keyboardType(.phonePad)"/>
      <:actions>
        <.button type="submit">
          Submit
        </.button>
      </:actions>
    </.simple_form>
    """
  end
end
```

For a complete list of accepted keyboard types, see the [UIKeyboardType](https://developer.apple.com/documentation/uikit/uikeyboardtype) documentation.

## Core Components

Setting up a LiveView Native application using the generators creates a `core_components.swiftui.ex` file. If you have the [liveview-native-live-form](https://github.com/liveview-native/liveview-native-live-form) dependency, this file includes function components for building forms.

To better understand how to work with each core component, refer to the `core_components.swiftui.ex` file generated in a Phoenix LiveView Native project. For the core components used in this Livebook, refer to the [core_components.swiftui.ex](https://github.com/liveview-native/kino_live_view_native/blob/main/apps/server_web/lib/server_web/components/core_components.swiftui.ex) from the Kino LiveView Native project.

We've already been using the two main functions, `simple_form/1` and `input/1`. These are abstractions on top of the native SwiftUI views and some custom views defined by the LiveView Native Live Form library.

in this section, we'll dive deeper into these abstractions so that you can build your own custom forms.



### Simple Form

Here's the `simple_form/1` definition.

<!-- livebook:{"force_markdown":true} -->

```elixir
  attr :for, :any, required: true, doc: "the datastructure for the form"
  attr :as, :any, default: nil, doc: "the server side parameter to collect all input under"

  attr :rest, :global,
    include: ~w(autocomplete name rel action enctype method novalidate target multipart),
    doc: "the arbitrary HTML attributes to apply to the form tag"

  slot :inner_block, required: true
  slot :actions, doc: "the slot for form actions, such as a submit button"

  def simple_form(assigns) do
    ~LVN"""
    <.form :let={f} for={@for} as={@as} {@rest}>
      <Form>
        <%= render_slot(@inner_block, f) %>
        <Section>
          <%= for action <- @actions do %>
            <%= render_slot(action, f) %>
          <% end %>
        </Section>
      </Form>
    </.form>
    """
  end
```

We show this to highlight the similarity between this form, and the one used in `core_components.ex`.

<!-- livebook:{"force_markdown":true} -->

```elixir
attr :for, :any, required: true, doc: "the datastructure for the form"
attr :as, :any, default: nil, doc: "the server side parameter to collect all input under"

attr :rest, :global,
  include: ~w(autocomplete name rel action enctype method novalidate target multipart),
  doc: "the arbitrary HTML attributes to apply to the form tag"

slot :inner_block, required: true
slot :actions, doc: "the slot for form actions, such as a submit button"

def simple_form(assigns) do
  ~H"""
  <.form :let={f} for={@for} as={@as} {@rest}>
    <div style="mt-10 space-y-8 bg-white">
      <%= render_slot(@inner_block, f) %>
      <div :for={action <- @actions} style="mt-2 flex items-center justify-between gap-6">
        <%= render_slot(action, f) %>
      </div>
    </div>
  </.form>
  """
end
```



### Input

The `type` attribute on the `input/1` component determines which View to render. Here's the same `input/1` definition.

<!-- livebook:{"force_markdown":true} -->

```elixir
attr :id, :any, default: nil
attr :name, :any
attr :label, :string, default: nil
attr :value, :any

attr :type, :string,
  default: "TextField",
  values: ~w(TextFieldLink DatePicker MultiDatePicker Picker SecureField Slider Stepper TextEditor TextField Toggle hidden)

attr :field, Phoenix.HTML.FormField,
  doc: "a form field struct retrieved from the form, for example: @form[:email]"

attr :errors, :list, default: []
attr :checked, :boolean, doc: "the checked flag for checkbox inputs"
attr :prompt, :string, default: nil, doc: "the prompt for select inputs"
attr :options, :list, doc: "the options to pass to Phoenix.HTML.Form.options_for_select/2"
attr :multiple, :boolean, default: false, doc: "the multiple flag for select inputs"

attr :min, :any, default: nil
attr :max, :any, default: nil

attr :placeholder, :string, default: nil

attr :readonly, :boolean, default: false

attr :autocomplete, :string,
  default: "on",
  values: ~w(on off)

attr :rest, :global,
  include: ~w(disabled step)

slot :inner_block

def input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
  # Input Definition
end
```

The `input/1` function then continues to call a separate function definition depending on the `type` attribute. For example, here's the `"TextField"` definition:

<!-- livebook:{"force_markdown":true} -->

```elixir
def input(%{type: "TextField"} = assigns) do
  ~LVN"""
  <VStack alignment="leading">
    <TextField id={@id} name={@name} text={@value} prompt={@prompt} {@rest}><%= @placeholder || @label %></TextField>
    <.error :for={msg <- @errors}><%= msg %></.error>
  </VStack>
  """
end
```

Here's a list of valid options with links to their documentation:

* [TextFieldLink](https://developer.apple.com/documentation/swiftui/textfieldlink)
* [DatePicker](https://developer.apple.com/documentation/swiftui/datepicker)
* [MultiDatePicker](https://developer.apple.com/documentation/swiftui/multidatepicker)
* [Picker](https://developer.apple.com/documentation/swiftui/picker)
* [SecureField](https://developer.apple.com/documentation/swiftui/securefield)
* [Slider](https://developer.apple.com/documentation/swiftui/slider)
* [Stepper](https://developer.apple.com/documentation/swiftui/stepper)
* [TextEditor](https://developer.apple.com/documentation/swiftui/texteditor)
* [TextField](https://developer.apple.com/documentation/swiftui/textfield)
* [Toggle](https://developer.apple.com/documentation/swiftui/toggle)
* hidden

For more on the form compatible views see the [Interactive SwiftUI Views](https://hexdocs.pm/liveview-client-swiftui/interactive-swiftui-views.html) guide.



### Core Components vs Views

SwiftUI Core Components attempts to make the API consistent and easy to remember between platforms. For that reason, we deviate somewhat from the interface used by SwiftUI.

Let's take the Slider view as an example. The Slider view accepts the `min` and `max` attributes instead of `lowerBound` and `upperBound` because they better reflect the html [range](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/range) slider. The component also accepts the `label` attribute instead of using children for the same reason.

<!-- livebook:{"force_markdown":true} -->

```elixir
  def input(%{type: "Slider"} = assigns) do
    ~LVN"""
    <VStack alignment="leading">
      <LabeledContent>
        <Text template="label"><%= @label %></Text>
        <Slider id={@id} name={@name} value={@value} lowerBound={@min} upperBound={@max} {@rest}><%= @label %></Slider>
      </LabeledContent>
      <.error :for={msg <- @errors}><%= msg %></.error>
    </VStack>
    """
  end
```



### Labels with Form Data

Sometimes you may wish to use data within the form separately as part of your UI. For example, let's say we want to have a Stepper view with a dynamic label based on the current step value. In these cases, you can access form data through the `@form.params`.

Here's an example showing how to have a dynamic label based on the Stepper view's current value. Evaluate the example below and run it in your simulator.

<!-- livebook:{"attrs":"eyJjb2RlIjoiZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZS5Td2lmdFVJIGRvXG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIFs6cmVuZGVyX2NvbXBvbmVudCwgZm9ybWF0OiA6c3dpZnR1aV1cblxuICBkZWYgcmVuZGVyKGFzc2lnbnMpIGRvXG4gICAgfkxWTlwiXCJcIlxuICAgIDwuc2ltcGxlX2Zvcm0gZm9yPXtAZm9ybX0gaWQ9XCJmb3JtXCIgcGh4LXN1Ym1pdD1cInN1Ym1pdFwiIHBoeC1jaGFuZ2U9XCJ2YWxpZGF0ZVwiPlxuICAgICAgPC5pbnB1dCBcbiAgICAgICAgZmllbGQ9e0Bmb3JtWzp2YWx1ZV19IFxuICAgICAgICB0eXBlPVwiU3RlcHBlclwiXG4gICAgICAgIGxhYmVsPXtcIlZhbHVlOiAje0Bmb3JtLnBhcmFtc1tcInZhbHVlXCJdfVwifVxuICAgICAgLz5cbiAgICAgIDw6YWN0aW9ucz5cbiAgICAgICAgPC5idXR0b24gdHlwZT1cInN1Ym1pdFwiPlxuICAgICAgICAgIFBpbmdcbiAgICAgICAgPC8uYnV0dG9uPlxuICAgICAgPC86YWN0aW9ucz5cbiAgICA8Ly5zaW1wbGVfZm9ybT5cbiAgICBcIlwiXCJcbiAgZW5kXG5lbmRcblxuZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZSBkb1xuICB1c2UgU2VydmVyV2ViLCA6bGl2ZV92aWV3XG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIDpsaXZlX3ZpZXdcblxuICBAaW1wbCB0cnVlXG4gIGRlZiBtb3VudChfcGFyYW1zLCBfc2Vzc2lvbiwgc29ja2V0KSBkb1xuICAgIHs6b2ssIGFzc2lnbihzb2NrZXQsIGZvcm06IHRvX2Zvcm0oJXtcInZhbHVlXCIgPT4gMH0sIGFzOiBcIm15X2Zvcm1cIikpfVxuICBlbmRcblxuICBAaW1wbCB0cnVlXG4gIGRlZiByZW5kZXIoYXNzaWducyksIGRvOiB+SFwiXCJcblxuICBAaW1wbCB0cnVlXG4gIGRlZiBoYW5kbGVfZXZlbnQoXCJzdWJtaXRcIiwgcGFyYW1zLCBzb2NrZXQpIGRvXG4gICAgezpub3JlcGx5LCBhc3NpZ24oc29ja2V0LCBmb3JtOiB0b19mb3JtKHBhcmFtcywgYXM6IFwibXlfZm9ybVwiKSl9XG5cbiAgZW5kXG5cbiAgQGltcGwgdHJ1ZVxuICBkZWYgaGFuZGxlX2V2ZW50KFwidmFsaWRhdGVcIiwgJXtcIm15X2Zvcm1cIiA9PiBwYXJhbXN9LCBzb2NrZXQpIGRvXG4gICAgezpub3JlcGx5LCBhc3NpZ24oc29ja2V0LCBmb3JtOiB0b19mb3JtKHBhcmFtcywgYXM6IFwibXlfZm9ybVwiKSl9XG4gIGVuZFxuZW5kIiwicGF0aCI6Ii8ifQ","chunks":[[0,85],[87,1061],[1150,49],[1201,51]],"kind":"Elixir.Server.SmartCells.LiveViewNative","livebook_object":"smart_cell"} -->

```elixir
defmodule ServerWeb.ExampleLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assigns) do
    ~LVN"""
    <.simple_form for={@form} id="form" phx-submit="submit" phx-change="validate">
      <.input 
        field={@form[:value]} 
        type="Stepper"
        label={"Value: #{@form.params["value"]}"}
      />
      <:actions>
        <.button type="submit">
          Ping
        </.button>
      </:actions>
    </.simple_form>
    """
  end
end

defmodule ServerWeb.ExampleLive do
  use ServerWeb, :live_view
  use ServerNative, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{"value" => 0}, as: "my_form"))}
  end

  @impl true
  def render(assigns), do: ~H""

  @impl true
  def handle_event("submit", params, socket) do
    {:noreply, assign(socket, form: to_form(params, as: "my_form"))}
  end

  @impl true
  def handle_event("validate", %{"my_form" => params}, socket) do
    {:noreply, assign(socket, form: to_form(params, as: "my_form"))}
  end
end
```

### Your Turn

Create a form that has `TextField`, `Slider`, `Toggle`, and `DatePicker` fields.

### Example Solution

```elixir
defmodule ServerWeb.ExampleLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assigns) do
    ~LVN"""
    <.simple_form for={@form} id="form" phx-submit="submit" phx-change="validate">
      <.input field={@form[:text]} type="TextField" placeholder="Enter a value" />
      <.input field={@form[:slider]} type="Slider"/>
      <.input field={@form[:toggle]} type="Toggle"/>
      <.input field={@form[:date_picker]} type="DatePicker"/>
      <:actions>
        <.button type="submit">
          Ping
        </.button>
      </:actions>
    </.simple_form>
    """
  end
end

defmodule ServerWeb.ExampleLive do
  use ServerWeb, :live_view
  use ServerNative, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}, as: "my_form"))}
  end

  @impl true
  def render(assigns), do: ""

  @impl true
  def handle_event("submit", params, socket) do
    IO.inspect(params, label: "Submitted")
    {:noreply, socket}
  end

  @impl true
  def handle_event("validate", params, socket) do
    IO.inspect(params, label: "Validating")
    {:noreply, socket}
  end
end
```



<!-- livebook:{"attrs":"eyJjb2RlIjoiZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZS5Td2lmdFVJIGRvXG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIFs6cmVuZGVyX2NvbXBvbmVudCwgZm9ybWF0OiA6c3dpZnR1aV1cblxuICBkZWYgcmVuZGVyKGFzc2lnbnMpIGRvXG4gICAgfkxWTlwiXCJcIlxuICAgIDwuc2ltcGxlX2Zvcm0gZm9yPXtAZm9ybX0gaWQ9XCJmb3JtXCIgcGh4LXN1Ym1pdD1cInN1Ym1pdFwiIHBoeC1jaGFuZ2U9XCJ2YWxpZGF0ZVwiPlxuICAgICAgPCEtLSBGb3JtIGZpZWxkcyBnbyBoZXJlIC0tPlxuICAgICAgPDphY3Rpb25zPlxuICAgICAgICA8LmJ1dHRvbiB0eXBlPVwic3VibWl0XCI+XG4gICAgICAgICAgUGluZ1xuICAgICAgICA8Ly5idXR0b24+XG4gICAgICA8LzphY3Rpb25zPlxuICAgIDwvLnNpbXBsZV9mb3JtPlxuICAgIFwiXCJcIlxuICBlbmRcbmVuZFxuXG5kZWZtb2R1bGUgU2VydmVyV2ViLkV4YW1wbGVMaXZlIGRvXG4gIHVzZSBTZXJ2ZXJXZWIsIDpsaXZlX3ZpZXdcbiAgdXNlIFNlcnZlck5hdGl2ZSwgOmxpdmVfdmlld1xuXG4gIEBpbXBsIHRydWVcbiAgZGVmIG1vdW50KF9wYXJhbXMsIF9zZXNzaW9uLCBzb2NrZXQpIGRvXG4gICAgezpvaywgYXNzaWduKHNvY2tldCwgZm9ybTogdG9fZm9ybSgle30sIGFzOiBcIm15X2Zvcm1cIikpfVxuICBlbmRcblxuICBAaW1wbCB0cnVlXG4gIGRlZiByZW5kZXIoYXNzaWducyksIGRvOiB+SFwiXCJcblxuICBAaW1wbCB0cnVlXG4gIGRlZiBoYW5kbGVfZXZlbnQoXCJzdWJtaXRcIiwgcGFyYW1zLCBzb2NrZXQpIGRvXG4gICAgSU8uaW5zcGVjdChwYXJhbXMsIGxhYmVsOiBcIlN1Ym1pdHRlZFwiKVxuICAgIHs6bm9yZXBseSwgc29ja2V0fVxuICBlbmRcblxuICBAaW1wbCB0cnVlXG4gIGRlZiBoYW5kbGVfZXZlbnQoXCJ2YWxpZGF0ZVwiLCBwYXJhbXMsIHNvY2tldCkgZG9cbiAgICBJTy5pbnNwZWN0KHBhcmFtcywgbGFiZWw6IFwiVmFsaWRhdGluZ1wiKVxuICAgIHs6bm9yZXBseSwgc29ja2V0fVxuICBlbmRcbmVuZCIsInBhdGgiOiIvIn0","chunks":[[0,85],[87,934],[1023,49],[1074,51]],"kind":"Elixir.Server.SmartCells.LiveViewNative","livebook_object":"smart_cell"} -->

```elixir
defmodule ServerWeb.ExampleLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assigns) do
    ~LVN"""
    <.simple_form for={@form} id="form" phx-submit="submit" phx-change="validate">
      <!-- Form fields go here -->
      <:actions>
        <.button type="submit">
          Ping
        </.button>
      </:actions>
    </.simple_form>
    """
  end
end

defmodule ServerWeb.ExampleLive do
  use ServerWeb, :live_view
  use ServerNative, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}, as: "my_form"))}
  end

  @impl true
  def render(assigns), do: ~H""

  @impl true
  def handle_event("submit", params, socket) do
    IO.inspect(params, label: "Submitted")
    {:noreply, socket}
  end

  @impl true
  def handle_event("validate", params, socket) do
    IO.inspect(params, label: "Validating")
    {:noreply, socket}
  end
end
```

### Native Views

The LiveView Native LiveForm library defines [a few custom SwiftUI views](https://github.com/liveview-native/liveview-native-live-form/tree/main/swiftui/Sources/LiveViewNativeLiveForm) such as `LiveForm` and `LiveSubmitButton`. Several core components use these components.

Typically, you won't need to use these views directly and will instead rely upon the core components directly.

## Mini Project: User Form

Taking everything you've learned, you're going to create a more complex user form with data validation and error displaying.



### User Changeset

First, create a `CustomUser` changeset below that handles data validation.

**Requirements**

* A user should have a `name` field
* A user should have a `password` string field of 10 or more characters. Note that for simplicity we are not hashing the password or following real security practices since our pretend application doesn't have a database. In real-world apps passwords should **never** be stored as a simple string, they should be encrypted.
* A user should have an `age` number field greater than `0` and less than `200`.
* A user should have an `email` field which matches an email format (including `@` is sufficient).
* A user should have a `accepted_terms` field which must be true.
* A user should have a `birthdate` field which is a date.
* All fields should be required

### Example Solution

```elixir
defmodule CustomUser do
  import Ecto.Changeset
  defstruct [:name, :password, :age, :email, :accepted_terms, :birthdate]

  @types %{
    name: :string,
    password: :string,
    age: :integer,
    email: :string,
    accepted_terms: :boolean,
    birthdate: :date
  }

  def changeset(user, params) do
    {user, @types}
    |> cast(params, Map.keys(@types))
    |> validate_required(Map.keys(@types))
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 10)
    |> validate_number(:age, greater_than: 0, less_than: 200)
    |> validate_acceptance(:accepted_terms)
  end
end
```



```elixir
defmodule CustomUser do
  # define the struct keys
  defstruct []

  # define the types
  @types %{}

  def changeset(user, params) do
    # Enter your solution
  end
end
```

### LiveView

Next, create a Live View that lets the user enter their information and displays errors for invalid information.

**Requirements**

* The `name` field should be a `TextField`.
* The `email` field should be a `TextField`.
* The `password` field should be a `SecureField`.
* The `age` field should be a `TextField` with a `.numberPad` keyboard or a `Slider`.
* The `accepted_terms` field should be a `Toggle`.
* The `birthdate` field should be a `DatePicker`.

### Example Solution

```elixir
defmodule ServerWeb.ExampleLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assigns) do
    ~LVN"""
    <!-- Form goes here -->
    <.simple_form for={@form} id="form" phx-submit="submit" phx-change="validate">
      <.input field={@form[:name]} type="TextField" placeholder="name" />
      <.input field={@form[:email]} type="TextField" placeholder="email" />
      <.input field={@form[:password]} type="SecureField" placeholder="password" />
      <.input field={@form[:age]} type="TextField" placeholder="age" style="keyboardType(.numberPad)" />
      <.input field={@form[:accepted_terms]} type="Toggle"/>
      <.input field={@form[:birthdate]} type="DatePicker"/>
      
      <:actions>
        <.button type="submit">
          Submit
        </.button>
      </:actions>
    </.simple_form>
    """
  end
end

defmodule ServerWeb.ExampleLive do
  use ServerWeb, :live_view
  use ServerNative, :live_view

  @impl true
  def mount(_params, _session, socket) do
    changeset = User.changeset(%CustomUser{}, %{})
    {:ok, assign(socket, form: to_form(changeset, as: :user))}
  end

  @impl true
  def render(assigns), do: ~H""

  @impl true
  def handle_event("submit", %{"user" => params}, socket) do
    changeset =
      CustomUser.changeset(%CustomUser{}, params)
      # Faking a Database insert action
      |> Map.put(:action, :insert)
      |> IO.inspect(label: "Form Field Values")

    {:noreply, assign(socket, form: to_form(changeset, as: :user))}
  end

  @impl true
  def handle_event("validate", %{"user" => params}, socket) do
    IO.inspect(params)
    changeset =
      CustomUser.changeset(%CustomUser{}, params)
      |> Map.put(:action, :validate)
      |> IO.inspect()

    {:noreply, assign(socket, form: to_form(changeset, as: :user))}
  end
end
```



<!-- livebook:{"attrs":"eyJjb2RlIjoiZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZS5Td2lmdFVJIGRvXG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIFs6cmVuZGVyX2NvbXBvbmVudCwgZm9ybWF0OiA6c3dpZnR1aV1cblxuICBkZWYgcmVuZGVyKGFzc2lnbnMpIGRvXG4gICAgfkxWTlwiXCJcIlxuICAgIDwhLS0gRm9ybSBnb2VzIGhlcmUgLS0+XG4gICAgXCJcIlwiXG4gIGVuZFxuZW5kXG5cbmRlZm1vZHVsZSBTZXJ2ZXJXZWIuRXhhbXBsZUxpdmUgZG9cbiAgdXNlIFNlcnZlcldlYiwgOmxpdmVfdmlld1xuICB1c2UgU2VydmVyTmF0aXZlLCA6bGl2ZV92aWV3XG5cbiAgQGltcGwgdHJ1ZVxuICBkZWYgbW91bnQoX3BhcmFtcywgX3Nlc3Npb24sIHNvY2tldCkgZG9cbiAgICAjIFJlbWVtYmVyIHRvIGFzc2lnbiB0aGUgZm9ybVxuICAgIHs6b2ssIHNvY2tldH1cbiAgZW5kXG5cbiAgQGltcGwgdHJ1ZVxuICBkZWYgcmVuZGVyKGFzc2lnbnMpLCBkbzogfkhcIlwiXG5cbiAgIyBFdmVudCBoYW5kbGVycyBmb3IgZm9ybSB2YWxpZGF0aW9uIGFuZCBzdWJtaXNzaW9uIGdvIGhlcmVcbmVuZCIsInBhdGgiOiIvIn0","chunks":[[0,85],[87,506],[595,49],[646,51]],"kind":"Elixir.Server.SmartCells.LiveViewNative","livebook_object":"smart_cell"} -->

```elixir
defmodule ServerWeb.ExampleLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assigns) do
    ~LVN"""
    <!-- Form goes here -->
    """
  end
end

defmodule ServerWeb.ExampleLive do
  use ServerWeb, :live_view
  use ServerNative, :live_view

  @impl true
  def mount(_params, _session, socket) do
    # Remember to assign the form
    {:ok, socket}
  end

  @impl true
  def render(assigns), do: ~H""

  # Event handlers for form validation and submission go here
end
```