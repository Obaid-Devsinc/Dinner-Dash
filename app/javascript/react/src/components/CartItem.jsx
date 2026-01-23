import React from "react";

function CartItem({ item, onUpdateQuantity, onRemove }) {
  const { product } = item;

  return (
    <div
      id={`cart_item_${product.id}`}
      className="flex flex-col sm:flex-row items-start sm:items-center gap-4 p-4 border border-gray-200 rounded-xl bg-white hover:shadow-md transition-shadow"
    >
      <div className="w-24 h-24 rounded-lg overflow-hidden bg-gray-100 shrink-0">
        <img
           src="http://127.0.0.1:3000/assets/unknown-0a9b9946.jpeg"
          alt={product.title}
          className="h-full w-full hover:scale-110 transition-transform duration-300"
        />
      </div>

      <div className="flex-1">
        <h3 className="font-medium text-gray-900 text-lg">{product.title}</h3>
        <p className="text-gray-600 mt-1">
          {product.description || "No description provided for this item."}
        </p>
        <p className="font-semibold text-gray-900 mt-2">
          ${product.price.toFixed(2)} each
        </p>
      </div>

      <div className="w-full sm:w-auto flex items-center justify-between flex-row sm:flex-col sm:items-end gap-3">
        <div className="flex sm:flex-col items-center sm:items-end gap-3">
          <div className="flex items-center gap-2">
            <div className="flex items-center border border-gray-300 rounded-lg">
              <button
                onClick={() => onUpdateQuantity(product.id, product.quantity - 1)}
                className="px-4 py-2 bg-gray-50 hover:bg-gray-100 text-gray-700 cursor-pointer"
              >
                -
              </button>

              <input
                type="text"
                value={product.quantity}
                className="w-12 text-center border-x border-gray-300 py-2"
                readOnly
              />

              <button
                onClick={() => onUpdateQuantity(product.id, product.quantity + 1)}
                className="px-4 py-2 bg-gray-50 hover:bg-gray-100 text-gray-700 cursor-pointer"
              >
                +
              </button>
            </div>
          </div>

          {/* Subtotal */}
          <p className="font-bold text-gray-900 text-lg">
            ${(product.price * product.quantity).toFixed(2)}
          </p>
        </div>

        <button
          onClick={() => onRemove(product.id)}
          className="text-red-500 hover:text-red-700 flex items-center gap-1 cursor-pointer"
        >
          <i className="fas fa-trash mr-1"></i> Remove
        </button>
      </div>
    </div>
  );
}


export default CartItem
