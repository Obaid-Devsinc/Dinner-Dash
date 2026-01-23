export const dispatchCartCount = (items) => {
  const quantity = items?.reduce((total, item) => total + (item.product?.quantity || 0), 0);
  window.dispatchEvent(new CustomEvent("cartCountUpdated", { detail: quantity }));
};
