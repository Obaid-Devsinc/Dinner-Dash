import React, { useEffect, useState } from "react";
import Fallback from "../components/Fallback";
import CartItem from "../components/CartItem";
import OrderSummary from "../components/CartSummary";
import { dispatchCartCount } from "../utils/cartEvents.js";
import { fetchCartItems, updateCartItemQuantity, removeCartItem } from "../services/cartService.js";

function Cart() {
  const [cartItems, setCartItems] = useState({
    items: [],
    subtotal: 0,
    tax: 0,
    total: 0
  });

  const loadCart = async () => {
    try {
      const data = await fetchCartItems();
      setCartItems(data);
      dispatchCartCount(data.items);
    } catch (err) {
      console.error("Error fetching cart:", err);
    }
  };

  const onUpdateQuantity = async (id, quantity) => {
    if (quantity < 1) return;
    try {
      const data = await updateCartItemQuantity(id, quantity);
      setCartItems(data);
      dispatchCartCount(data.items);
    } catch (err) {
      console.error("Error updating quantity:", err);
    }
  };

  const onRemove = async (id) => {
    if (!window.confirm("Are you sure?")) return;
    try {
      const data = await removeCartItem(id);
      setCartItems(data);
      dispatchCartCount(data.items);
    } catch (err) {
      console.error("Error removing item:", err);
    }
  };

  useEffect(() => {
    loadCart();
  }, []);

  if (!cartItems.items.length) {
    return (
      <section className="min-h-screen py-8 sm:py-12 px-4 sm:px-6 flex justify-center">
        <Fallback />
      </section>
    );
  }

  return (
    <section className="min-h-screen py-8 sm:py-12 px-4 sm:px-6">
      <div className="max-w-6xl mx-auto grid grid-cols-1 lg:grid-cols-3 gap-8">
        <div className="lg:col-span-2 space-y-3">
          {cartItems.items.map((item) => (
            <CartItem
              key={item.product.id}
              item={item}
              onUpdateQuantity={onUpdateQuantity}
              onRemove={onRemove}
            />
          ))}
        </div>
        <div>
          <OrderSummary
           subtotal={cartItems.subtotal}
           tax={cartItems.tax}
           total={cartItems.total}
           />
        </div>
      </div>
    </section>
  );
}

export default Cart;
