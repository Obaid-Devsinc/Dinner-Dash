import React from "react";

const CartSummary = ({ subtotal, tax, total }) => {
  const container = document.getElementById("root");
  const isUserSignedIn = container?.dataset.userSignedIn === "true";

  return (
    <div className="lg:col-span-1">
      <div className="sticky top-8 p-6 border border-gray-200 rounded-xl bg-gray-50">
        <h3 className="text-lg font-bold text-gray-900 mb-6">Order Summary</h3>

        <div className="space-y-4">
          <div className="flex justify-between">
            <span className="text-gray-600">Subtotal</span>
            <span className="font-semibold">${subtotal.toFixed(2)}</span>
          </div>

          <div className="flex justify-between">
            <span className="text-gray-600">Shipping</span>
            <span className="font-semibold text-green-600">FREE</span>
          </div>

          <div className="flex justify-between">
            <span className="text-gray-600">Tax - 8%</span>
            <span className="font-semibold">${tax.toFixed(2)}</span>
          </div>

          <div className="border-t border-gray-300 pt-4 mt-4">
            <div className="flex justify-between items-center">
              <span className="text-xl font-bold text-gray-900">Total</span>
              <span className="text-xl font-bold text-gray-900">${total.toFixed(2)}</span>
            </div>
          </div>
        </div>

        {isUserSignedIn ? (
          <a href="/orders/new">
            <button className="w-full mt-6 bg-black text-white py-4 rounded-lg hover:bg-gray-800 transition-colors font-medium cursor-pointer">
              <i className="fas fa-lock mr-2"></i>
              Proceed to Checkout
            </button>
          </a>
        ) : (
          <div className="pt-10 bg-blue-50 rounded-lg text-center">
            <a href="/users/sign_in" className="text-blue-600 hover:text-blue-800 font-medium">
              Please login to checkout
            </a>
          </div>
        )}

        <a href="/items" className="mt-3 flex items-center gap-2 border border-gray-300 text-gray-700 py-3 rounded-lg hover:bg-gray-50 transition-colors font-medium justify-center">
          <i className="fas fa-arrow-left"></i> Continue Shopping
        </a>
      </div>
    </div>
  );
};

export default CartSummary;
