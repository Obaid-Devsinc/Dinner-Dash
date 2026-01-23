import axios from "../axios/axiosInstance.js";

const fetchCartItems = async () => {
  const { data } = await axios.get("/cart.json");
  return data;
};

const updateCartItemQuantity = async (id, quantity) => {
  const { data } = await axios.patch(`/cart_items/${id}.json`, { id, quantity });
  return data;
};

const removeCartItem = async (id) => {
  const { data } = await axios.delete(`/cart_items/${id}.json`);
  return data;
};

export { fetchCartItems, updateCartItemQuantity, removeCartItem };
