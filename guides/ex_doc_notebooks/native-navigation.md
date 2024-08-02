# Native Navigation

[![Run in Livebook](https://livebook.dev/badge/v1/blue.svg)](https://livebook.dev/run?url=https%3A%2F%2Fraw.githubusercontent.com%2Fliveview-native%2Flive_view_native%2Fmain%2Fguides%livebooks%native-navigation.livemd)

## Overview

This guide will teach you how to create multi-page applications using LiveView Native. We will cover navigation patterns specific to native applications and how to reuse the existing navigation patterns available in LiveView.

Before diving in, you should have a basic understanding of navigation in LiveView. You should be familiar with the [redirect/2](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#redirect/2), [push_patch/2](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#push_patch/2) and [push_navigate/2](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#push_navigate/2) functions, which are used to trigger navigation from within a LiveView. Additionally, you should know how to define routes in the router using the [live/4](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.Router.html#live/4) macro.

## NavigationStack

LiveView Native applications are generally wrapped in a [NavigationStack](https://developer.apple.com/documentation/swiftui/navigationstack) view. This view usually exists in the `root.swiftui.heex` file, which looks something like the following:

<!-- livebook:{"force_markdown":true} -->

```elixir
<.csrf_token />
<Style url={~p"/assets/app.swiftui.styles"} />
<NavigationStack>
  <%= @inner_content %>
</NavigationStack>
```

The `NavigationStack` view stacks pages on top of eachother. To see this in action, we'll walk through an example of viewing the LiveView Native template code sent by the application.

Evaluate the code cell below. We'll view the source code in a moment.

<!-- livebook:{"attrs":"eyJjb2RlIjoiZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZS5Td2lmdFVJIGRvXG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIFs6cmVuZGVyX2NvbXBvbmVudCwgZm9ybWF0OiA6c3dpZnR1aV1cblxuICBkZWYgcmVuZGVyKGFzc2lnbnMpIGRvXG4gICAgfkxWTlwiXCJcIlxuICAgIDxUZXh0PkhlbGxvLCBmcm9tIExpdmVWaWV3IE5hdGl2ZSE8L1RleHQ+XG4gICAgXCJcIlwiXG4gIGVuZFxuZW5kXG5cbmRlZm1vZHVsZSBTZXJ2ZXJXZWIuRXhhbXBsZUxpdmUgZG9cbiAgdXNlIFNlcnZlcldlYiwgOmxpdmVfdmlld1xuICB1c2UgU2VydmVyTmF0aXZlLCA6bGl2ZV92aWV3XG5cbiAgQGltcGwgdHJ1ZVxuICBkZWYgcmVuZGVyKGFzc2lnbnMpLCBkbzogfkhcIlwiXG5lbmQiLCJwYXRoIjoiLyJ9","chunks":[[0,85],[87,347],[436,49],[487,51]],"kind":"Elixir.Server.SmartCells.LiveViewNative","livebook_object":"smart_cell"} -->

```elixir
defmodule ServerWeb.ExampleLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assigns) do
    ~LVN"""
    <Text>Hello, from LiveView Native!</Text>
    """
  end
end

defmodule ServerWeb.ExampleLive do
  use ServerWeb, :live_view
  use ServerNative, :live_view

  @impl true
  def render(assigns), do: ~H""
end
```

Visit http://localhost:4000/?_format=swiftui. The `?_format` query parameter specifies the Phoenix server should respond with the swiftui template rather than the web template. You should see source code similar to the example below. We've replaced long tokens with `"some token"` for the sake of readability.

```html
<csrf-token value="sometoken"></csrf-token>
<Style url="/assets/app.swiftui.styles"></Style>
<NavigationStack>
  <div id="phx-F8bMeC0NpvsZjPJC" data-phx-main data-phx-session="sometoken" data-phx-static="sometoken">
    <Text>Hello, from LiveView Native!</Text>
  </div>
</NavigationStack><iframe hidden height="0" width="0" src="/phoenix/live_reload/frame"></iframe>
```

Notice the [NavigationStack](https://developer.apple.com/documentation/swiftui/navigationstack) view wraps the template. This view manages the state of navigation history and allows for navigating back to previous pages.

## Navigation Links

We can use the [NavigationLink](https://liveview-native.github.io/liveview-client-swiftui/documentation/liveviewnative/navigationlink) view for native navigation, similar to how we can use the [.link](https://hexdocs.pm/phoenix_live_view/Phoenix.Component.html#link/1) component with the `navigate` attribute for web navigation.

We've created the same example of navigating between the `Main` and `About` pages. Each page using a `NavigationLink` to navigate to the other page.

Evaluate **both** of the code cells below and click on the `NavigationLink` in your simulator to navigate between the two views.

<!-- livebook:{"attrs":"eyJjb2RlIjoiZGVmbW9kdWxlIFNlcnZlcldlYi5BYm91dExpdmUuU3dpZnRVSSBkb1xuICB1c2UgU2VydmVyTmF0aXZlLCBbOnJlbmRlcl9jb21wb25lbnQsIGZvcm1hdDogOnN3aWZ0dWldXG5cbiAgZGVmIHJlbmRlcihhc3NpZ25zKSBkb1xuICAgIH5MVk5cIlwiXCJcbiAgICA8VGV4dD5Zb3UgYXJlIG9uIHRoZSBhYm91dCBwYWdlPC9UZXh0PlxuICAgIDxOYXZpZ2F0aW9uTGluayBkZXN0aW5hdGlvbj17fnBcIi9cIn0+XG4gICAgICAgIDxUZXh0PlRvIEhvbWU8L1RleHQ+XG4gICAgPC9OYXZpZ2F0aW9uTGluaz5cbiAgICBcIlwiXCJcbiAgZW5kXG5lbmRcblxuZGVmbW9kdWxlIFNlcnZlcldlYi5BYm91dExpdmUgZG9cbiAgdXNlIFNlcnZlcldlYiwgOmxpdmVfdmlld1xuICB1c2UgU2VydmVyTmF0aXZlLCA6bGl2ZV92aWV3XG5cbiAgQGltcGwgdHJ1ZVxuICBkZWYgcmVuZGVyKGFzc2lnbnMpLCBkbzogfkhcIlwiXG5lbmQiLCJwYXRoIjoiL2Fib3V0In0","chunks":[[0,85],[87,432],[521,54],[577,51]],"kind":"Elixir.Server.SmartCells.LiveViewNative","livebook_object":"smart_cell"} -->

```elixir
defmodule ServerWeb.AboutLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assigns) do
    ~LVN"""
    <Text>You are on the about page</Text>
    <NavigationLink destination={~p"/"}>
        <Text>To Home</Text>
    </NavigationLink>
    """
  end
end

defmodule ServerWeb.AboutLive do
  use ServerWeb, :live_view
  use ServerNative, :live_view

  @impl true
  def render(assigns), do: ~H""
end
```

<!-- livebook:{"attrs":"eyJjb2RlIjoiZGVmbW9kdWxlIFNlcnZlcldlYi5Ib21lTGl2ZS5Td2lmdFVJIGRvXG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIFs6cmVuZGVyX2NvbXBvbmVudCwgZm9ybWF0OiA6c3dpZnR1aV1cblxuICBkZWYgcmVuZGVyKGFzc2lnbnMpIGRvXG4gICAgfkxWTlwiXCJcIlxuICAgIDxUZXh0PllvdSBhcmUgb24gdGhlIG1haW4gcGFnZTwvVGV4dD5cbiAgICA8TmF2aWdhdGlvbkxpbmsgZGVzdGluYXRpb249e35wXCIvYWJvdXRcIn0+XG4gICAgICAgIDxUZXh0PlRvIEFib3V0PC9UZXh0PlxuICAgIDwvTmF2aWdhdGlvbkxpbms+XG4gICAgXCJcIlwiXG4gIGVuZFxuZW5kXG5cbmRlZm1vZHVsZSBTZXJ2ZXJXZWIuSG9tZUxpdmUgZG9cbiAgdXNlIFNlcnZlcldlYiwgOmxpdmVfdmlld1xuICB1c2UgU2VydmVyTmF0aXZlLCA6bGl2ZV92aWV3XG5cbiAgQGltcGwgdHJ1ZVxuICBkZWYgcmVuZGVyKGFzc2lnbnMpLCBkbzogfkhcIlwiXG5lbmQiLCJwYXRoIjoiLyJ9","chunks":[[0,85],[87,435],[524,49],[575,51]],"kind":"Elixir.Server.SmartCells.LiveViewNative","livebook_object":"smart_cell"} -->

```elixir
defmodule ServerWeb.HomeLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assigns) do
    ~LVN"""
    <Text>You are on the main page</Text>
    <NavigationLink destination={~p"/about"}>
        <Text>To About</Text>
    </NavigationLink>
    """
  end
end

defmodule ServerWeb.HomeLive do
  use ServerWeb, :live_view
  use ServerNative, :live_view

  @impl true
  def render(assigns), do: ~H""
end
```

The `destination` attribute works the same as the `navigate` attribute on the web. The current LiveView will shut down, and a new one will mount without re-establishing a new socket connection.

## Push Navigation

For LiveView Native views, we can still use the same [redirect/2](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#redirect/2), [push_patch/2](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#push_patch/2), and [push_navigate/2](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#push_navigate/2) functions used in typical LiveViews.

These functions are preferable over `NavigationLink` views when you want to share navigation handlers between web and native, and/or when you want to have more customized navigation handling.

Evaluate **both** of the code cells below and click on the `Button` view in your simulator that triggers the `handle_event/3` navigation handler to navigate between the two views.

<!-- livebook:{"attrs":"eyJjb2RlIjoiZGVmbW9kdWxlIFNlcnZlcldlYi5NYWluTGl2ZS5Td2lmdFVJIGRvXG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIFs6cmVuZGVyX2NvbXBvbmVudCwgZm9ybWF0OiA6c3dpZnR1aV1cblxuICBkZWYgcmVuZGVyKGFzc2lnbnMpIGRvXG4gICAgfkxWTlwiXCJcIlxuICAgIDxUZXh0PllvdSBhcmUgb24gdGhlIE1haW4gUGFnZTwvVGV4dD5cbiAgICA8QnV0dG9uIHBoeC1jbGljaz1cInRvLWFib3V0XCI+R28gdG8gQWJvdXQgcGFnZTwvQnV0dG9uPlxuICAgIFwiXCJcIlxuICBlbmRcbmVuZFxuXG5kZWZtb2R1bGUgU2VydmVyV2ViLk1haW5MaXZlIGRvXG4gIHVzZSBTZXJ2ZXJXZWIsIDpsaXZlX3ZpZXdcbiAgdXNlIFNlcnZlck5hdGl2ZSwgOmxpdmVfdmlld1xuXG4gIEBpbXBsIHRydWVcbiAgZGVmIHJlbmRlcihhc3NpZ25zKSwgZG86IH5IXCJcIlxuXG4gIEBpbXBsIHRydWVcbiAgZGVmIGhhbmRsZV9ldmVudChcInRvLWFib3V0XCIsIF9wYXJhbXMsIHNvY2tldCkgZG9cbiAgICB7Om5vcmVwbHksIHB1c2hfbmF2aWdhdGUoc29ja2V0LCB0bzogXCIvYWJvdXRcIil9XG4gIGVuZFxuZW5kIiwicGF0aCI6Ii8ifQ","chunks":[[0,85],[87,519],[608,49],[659,51]],"kind":"Elixir.Server.SmartCells.LiveViewNative","livebook_object":"smart_cell"} -->

```elixir
defmodule ServerWeb.MainLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assigns) do
    ~LVN"""
    <Text>You are on the Main Page</Text>
    <Button phx-click="to-about">Go to About page</Button>
    """
  end
end

defmodule ServerWeb.MainLive do
  use ServerWeb, :live_view
  use ServerNative, :live_view

  @impl true
  def render(assigns), do: ~H""

  @impl true
  def handle_event("to-about", _params, socket) do
    {:noreply, push_navigate(socket, to: "/about")}
  end
end
```

<!-- livebook:{"attrs":"eyJjb2RlIjoiZGVmbW9kdWxlIFNlcnZlcldlYi5BYm91dExpdmUuU3dpZnRVSSBkb1xuICB1c2UgU2VydmVyTmF0aXZlLCBbOnJlbmRlcl9jb21wb25lbnQsIGZvcm1hdDogOnN3aWZ0dWldXG5cbiAgZGVmIHJlbmRlcihhc3NpZ25zKSBkb1xuICAgIH5MVk5cIlwiXCJcbiAgICA8VGV4dD5Zb3UgYXJlIG9uIHRoZSBBYm91dCBQYWdlPC9UZXh0PlxuICAgIDxCdXR0b24gcGh4LWNsaWNrPVwidG8tbWFpblwiPkdvIHRvIE1haW4gcGFnZTwvQnV0dG9uPlxuICAgIFwiXCJcIlxuICBlbmRcbmVuZFxuXG5kZWZtb2R1bGUgU2VydmVyV2ViLkFib3V0TGl2ZSBkb1xuICB1c2UgU2VydmVyV2ViLCA6bGl2ZV92aWV3XG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIDpsaXZlX3ZpZXdcblxuICBAaW1wbCB0cnVlXG4gIGRlZiByZW5kZXIoYXNzaWducyksIGRvOiB+SFwiXCJcblxuICAgIEBpbXBsIHRydWVcbiAgZGVmIGhhbmRsZV9ldmVudChcInRvLW1haW5cIiwgX3BhcmFtcywgc29ja2V0KSBkb1xuICAgIHs6bm9yZXBseSwgcHVzaF9uYXZpZ2F0ZShzb2NrZXQsIHRvOiBcIi9cIil9XG4gIGVuZFxuZW5kIiwicGF0aCI6Ii9hYm91dCJ9","chunks":[[0,85],[87,516],[605,54],[661,51]],"kind":"Elixir.Server.SmartCells.LiveViewNative","livebook_object":"smart_cell"} -->

```elixir
defmodule ServerWeb.AboutLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assigns) do
    ~LVN"""
    <Text>You are on the About Page</Text>
    <Button phx-click="to-main">Go to Main page</Button>
    """
  end
end

defmodule ServerWeb.AboutLive do
  use ServerWeb, :live_view
  use ServerNative, :live_view

  @impl true
  def render(assigns), do: ~H""

  @impl true
  def handle_event("to-main", _params, socket) do
    {:noreply, push_navigate(socket, to: "/")}
  end
end
```

## Routing

The `KinoLiveViewNative` smart cells used in this guide automatically define routes for us. Be aware there is no difference between how we define routes for LiveView or LiveView Native.

The routes for the main and about pages might look like the following in the router:

<!-- livebook:{"force_markdown":true} -->

```elixir
live "/", Server.MainLive
live "/about", Server.AboutLive
```

## Native Navigation Events

LiveView Native navigation mirrors the same navigation behavior you'll find on the web.

Evaluate the example below and press each button. Notice that:

1. `redirect/2` triggers the `mount/3` callback re-establishes a socket connection.
2. `push_navigate/2` triggers the `mount/3` callbcak and re-uses the existing socket connection.
3. `push_patch/2` does not trigger the `mount/3` callback, but does trigger the `handle_params/3` callback. This is often useful when using navigation to trigger page changes such as displaying a modal or overlay.

You can see this for yourself using the following example. Click each of the buttons for redirect, navigate, and patch behavior.

<!-- livebook:{"attrs":"eyJjb2RlIjoiIyBUaGlzIG1vZHVsZSBidWlsdCBmb3IgZXhhbXBsZSBwdXJwb3NlcyB0byBwZXJzaXN0IGxvZ3MgYmV0d2VlbiBtb3VudGluZyBMaXZlVmlld3MuXG5kZWZtb2R1bGUgUGVyc2lzdGFudExvZ3MgZG9cbiAgZGVmIGdldCBkb1xuICAgIDpwZXJzaXN0ZW50X3Rlcm0uZ2V0KDpsb2dzKVxuICBlbmRcblxuICBkZWYgcHV0KGxvZykgd2hlbiBpc19iaW5hcnkobG9nKSBkb1xuICAgIDpwZXJzaXN0ZW50X3Rlcm0ucHV0KDpsb2dzLCBbe2xvZywgVGltZS51dGNfbm93KCl9IHwgZ2V0KCldKVxuICBlbmRcblxuICBkZWYgcmVzZXQgZG9cbiAgICA6cGVyc2lzdGVudF90ZXJtLnB1dCg6bG9ncywgW10pXG4gIGVuZFxuZW5kXG5cblBlcnNpc3RhbnRMb2dzLnJlc2V0KClcblxuZGVmbW9kdWxlIFNlcnZlcldlYi5FeGFtcGxlTGl2ZS5Td2lmdFVJIGRvXG4gIHVzZSBTZXJ2ZXJOYXRpdmUsIFs6cmVuZGVyX2NvbXBvbmVudCwgZm9ybWF0OiA6c3dpZnR1aV1cblxuICBkZWYgcmVuZGVyKGFzc2lnbnMpIGRvXG4gICAgfkxWTlwiXCJcIlxuICAgIDxCdXR0b24gcGh4LWNsaWNrPVwicmVkaXJlY3RcIj5SZWRpcmVjdDwvQnV0dG9uPlxuICAgIDxCdXR0b24gcGh4LWNsaWNrPVwibmF2aWdhdGVcIj5OYXZpZ2F0ZTwvQnV0dG9uPlxuICAgIDxCdXR0b24gcGh4LWNsaWNrPVwicGF0Y2hcIj5QYXRjaDwvQnV0dG9uPlxuICAgIDxTY3JvbGxWaWV3PlxuICAgICAgPEdyaWQ+XG4gICAgICA8R3JpZFJvdz48VGV4dD5Tb2NrZXQgSUQ8L1RleHQ+PFRleHQ+PCU9IEBzb2NrZXRfaWQgJT48L1RleHQ+PC9HcmlkUm93PlxuICAgICAgPEdyaWRSb3c+PFRleHQ+TGl2ZVZpZXcgUElEOjwvVGV4dD48VGV4dD48JT0gQGxpdmVfdmlld19waWQgJT48L1RleHQ+PC9HcmlkUm93PlxuICAgICAgPCU9IGZvciB7bG9nLCB0aW1lfSA8LSBFbnVtLnJldmVyc2UoQGxvZ3MpIGRvICU+XG4gICAgICAgIDxHcmlkUm93PlxuICAgICAgICAgIDxUZXh0PjwlPSBDYWxlbmRhci5zdHJmdGltZSh0aW1lLCBcIiVIOiVNOiVTXCIpICU+OjwvVGV4dD5cbiAgICAgICAgICA8VGV4dD48JT0gbG9nICU+PC9UZXh0PlxuICAgICAgICA8L0dyaWRSb3c+XG4gICAgICA8JSBlbmQgJT5cbiAgICAgIDwvR3JpZD5cbiAgICA8L1Njcm9sbFZpZXc+XG4gICAgXCJcIlwiXG4gIGVuZFxuZW5kXG5cbmRlZm1vZHVsZSBTZXJ2ZXJXZWIuRXhhbXBsZUxpdmUgZG9cbiAgdXNlIFNlcnZlcldlYiwgOmxpdmVfdmlld1xuICB1c2UgU2VydmVyTmF0aXZlLCA6bGl2ZV92aWV3XG5cbiAgQGltcGwgdHJ1ZVxuICBkZWYgbW91bnQoX3BhcmFtcywgX3Nlc3Npb24sIHNvY2tldCkgZG9cbiAgICBQZXJzaXN0YW50TG9ncy5wdXQoXCJNT1VOVFwiKVxuICAgIHs6b2ssXG4gICAgIGFzc2lnbihzb2NrZXQsXG4gICAgICAgc29ja2V0X2lkOiBzb2NrZXQuaWQsXG4gICAgICAgY29ubmVjdGVkOiBjb25uZWN0ZWQ/KHNvY2tldCksXG4gICAgICAgbG9nczogUGVyc2lzdGFudExvZ3MuZ2V0KCksXG4gICAgICAgbGl2ZV92aWV3X3BpZDogaW5zcGVjdChzZWxmKCkpXG4gICAgICl9XG4gIGVuZFxuXG4gIEBpbXBsIHRydWVcbiAgZGVmIGhhbmRsZV9wYXJhbXMoX3BhcmFtcywgX3VybCwgc29ja2V0KSBkb1xuICAgIFBlcnNpc3RhbnRMb2dzLnB1dChcIkhBTkRMRSBQQVJBTVNcIilcblxuICAgIHs6bm9yZXBseSwgYXNzaWduKHNvY2tldCwgOmxvZ3MsIFBlcnNpc3RhbnRMb2dzLmdldCgpKX1cbiAgZW5kXG5cbiAgQGltcGwgdHJ1ZVxuICBkZWYgcmVuZGVyKGFzc2lnbnMpLFxuICAgIGRvOiB+SFwiXCJcblxuICBAaW1wbCB0cnVlXG4gIGRlZiBoYW5kbGVfZXZlbnQoXCJyZWRpcmVjdFwiLCBfcGFyYW1zLCBzb2NrZXQpIGRvXG4gICAgUGVyc2lzdGFudExvZ3MucmVzZXQoKVxuICAgIFBlcnNpc3RhbnRMb2dzLnB1dChcIi0tUkVESVJFQ1RJTkctLVwiKVxuICAgIHs6bm9yZXBseSwgcmVkaXJlY3Qoc29ja2V0LCB0bzogXCIvXCIpfVxuICBlbmRcblxuICBkZWYgaGFuZGxlX2V2ZW50KFwibmF2aWdhdGVcIiwgX3BhcmFtcywgc29ja2V0KSBkb1xuICAgIFBlcnNpc3RhbnRMb2dzLnB1dChcIi0tLU5BVklHQVRJTkctLS1cIilcbiAgICB7Om5vcmVwbHksIHB1c2hfbmF2aWdhdGUoc29ja2V0LCB0bzogXCIvXCIpfVxuICBlbmRcblxuICBkZWYgaGFuZGxlX2V2ZW50KFwicGF0Y2hcIiwgX3BhcmFtcywgc29ja2V0KSBkb1xuICAgIFBlcnNpc3RhbnRMb2dzLnB1dChcIi0tLS1QQVRDSElORy0tLS1cIilcbiAgICB7Om5vcmVwbHksIHB1c2hfcGF0Y2goc29ja2V0LCB0bzogXCIvXCIpfVxuICBlbmRcbmVuZCIsInBhdGgiOiIvIn0","chunks":[[0,85],[87,2159],[2248,49],[2299,51]],"kind":"Elixir.Server.SmartCells.LiveViewNative","livebook_object":"smart_cell"} -->

```elixir
# This module built for example purposes to persist logs between mounting LiveViews.
defmodule PersistantLogs do
  def get do
    :persistent_term.get(:logs)
  end

  def put(log) when is_binary(log) do
    :persistent_term.put(:logs, [{log, Time.utc_now()} | get()])
  end

  def reset do
    :persistent_term.put(:logs, [])
  end
end

PersistantLogs.reset()

defmodule ServerWeb.ExampleLive.SwiftUI do
  use ServerNative, [:render_component, format: :swiftui]

  def render(assigns) do
    ~LVN"""
    <Button phx-click="redirect">Redirect</Button>
    <Button phx-click="navigate">Navigate</Button>
    <Button phx-click="patch">Patch</Button>
    <ScrollView>
      <Grid>
      <GridRow><Text>Socket ID</Text><Text><%= @socket_id %></Text></GridRow>
      <GridRow><Text>LiveView PID:</Text><Text><%= @live_view_pid %></Text></GridRow>
      <%= for {log, time} <- Enum.reverse(@logs) do %>
        <GridRow>
          <Text><%= Calendar.strftime(time, "%H:%M:%S") %>:</Text>
          <Text><%= log %></Text>
        </GridRow>
      <% end %>
      </Grid>
    </ScrollView>
    """
  end
end

defmodule ServerWeb.ExampleLive do
  use ServerWeb, :live_view
  use ServerNative, :live_view

  @impl true
  def mount(_params, _session, socket) do
    PersistantLogs.put("MOUNT")

    {:ok,
     assign(socket,
       socket_id: socket.id,
       connected: connected?(socket),
       logs: PersistantLogs.get(),
       live_view_pid: inspect(self())
     )}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    PersistantLogs.put("HANDLE PARAMS")

    {:noreply, assign(socket, :logs, PersistantLogs.get())}
  end

  @impl true
  def render(assigns),
    do: ~H""

  @impl true
  def handle_event("redirect", _params, socket) do
    PersistantLogs.reset()
    PersistantLogs.put("--REDIRECTING--")
    {:noreply, redirect(socket, to: "/")}
  end

  def handle_event("navigate", _params, socket) do
    PersistantLogs.put("---NAVIGATING---")
    {:noreply, push_navigate(socket, to: "/")}
  end

  def handle_event("patch", _params, socket) do
    PersistantLogs.put("----PATCHING----")
    {:noreply, push_patch(socket, to: "/")}
  end
end
```