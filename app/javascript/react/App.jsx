import React from "react";
import ReactDOM from "react-dom/client";
import Cart from "./src/pages/Cart";

function App() {
  return <Cart/>
}

function mountReact() {
  const container = document.getElementById("root");
  if (container) {
    const root = ReactDOM.createRoot(container);
    root.render(<App />);
  }
}

document.addEventListener("DOMContentLoaded", mountReact);
document.addEventListener("turbo:load", mountReact);
