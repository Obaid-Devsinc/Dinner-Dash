import React, { useEffect, useState } from "react";
import Fallback from "../components/Fallback";
import OrderSummary from "../components/CartSummary";
import CartItem from "../components/CartItem";
import axios from "axios";

const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content;

axios.defaults.headers.common["X-CSRF-Token"] = csrfToken;
axios.defaults.headers.common["Accept"] = "application/json";

function Cart() {
  const [cartItems, setCartItems] = useState({ items: [], subtotal: 0, tax: 0, total: 0 });

  const BASEURL = "http://127.0.0.1:3000";

  async function fetchCartItems() {
    try {
      const { data } = await axios.get(`${BASEURL}/cart.json`);
      setCartItems(data);
    } catch (error) {
      console.error("Error fetching cart items:", error);
    }
  }

  async function onUpdateQuantity(id, quantity) {
    try {
      if (quantity < 1) return;
      await axios.patch(`${BASEURL}/cart_items/${id}.json`, { quantity });
      fetchCartItems();
    } catch (error) {
      console.error("Error updating quantity:", error);
    }
  }

  async function onRemove(id) {
    const confirmed = window.confirm("Are you sure?");
    if (!confirmed) return;

    try {
      const { data } = await axios.delete(`${BASEURL}/cart_items/${id}.json`);
      setCartItems(data);
    } catch (error) {
      console.error("Error removing item:", error);
    }
  }

  useEffect(() => {
    fetchCartItems();
  }, []);

  return (
    <section className="min-h-screen py-8 sm:py-12 px-4 sm:px-6">
      <div className="max-w-6xl mx-auto">
        {cartItems.items.length > 0 ? (
          <div id="cart_items_container" className="grid grid-cols-1 lg:grid-cols-3 gap-8">
            <div className="lg:col-span-2 space-y-3">
              {cartItems.items.map((item) => (
                <CartItem key={item.product.id} item={item} onUpdateQuantity={onUpdateQuantity} onRemove={onRemove} />
              ))}
            </div>
            <div id="order_summary_container">
              <OrderSummary subtotal={cartItems.subtotal} tax={cartItems.tax} total={cartItems.total} />
            </div>
          </div>
        ) : (
          <div className="flex justify-center">
            <Fallback />
          </div>
        )}
      </div>
    </section>
  );
}

export default Cart;
