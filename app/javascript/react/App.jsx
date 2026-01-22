import React from "react";
import ReactDOM from "react-dom/client";
import Cart from "./src/pages/Cart";

function App() {
  return <Cart/>
}

document.addEventListener("DOMContentLoaded", () => {
  const container = document.getElementById("root");
  if (container) {
    const root = ReactDOM.createRoot(container);
    root.render(<App />);
  }
});
