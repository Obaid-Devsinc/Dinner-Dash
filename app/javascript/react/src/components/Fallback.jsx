import React from 'react'

const Fallback = () => {
  return (
   <div className="h-[70vh] w-full flex justify-center items-center">
  <div className="space-y-2 flex flex-col justify-center items-center">
    <img src="http://127.0.0.1:3000/assets/no_product-1314b14b.avif" alt="no_image" className='w-[150px]' />
    <p className="bruno">No items in the cart</p>
  </div>
</div>

  )
}

export default Fallback
