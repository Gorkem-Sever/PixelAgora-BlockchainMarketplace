import { FiCalendar } from 'react-icons/fi'
import { FaLocationDot } from "react-icons/fa6";
import { FaHandshakeSimple } from "react-icons/fa6";

const Description = ({ product }) => {
  return (
    <div className="py-5 border-b-2 border-b-slate-200 space-y-4">
      <h1 className="text-xl font-semibold">Description</h1>
      <p className="text-slate-500 text-lg w-full sm:w-4/5">{product?.description}</p>

      <div className=" flex space-x-4 ">
        <FaLocationDot className="text-4xl" />
        <div>
          <h1 className="text-xl font-semibold">Location</h1>
          <p className="cursor-pointer">{product?.location}</p>
        </div>
      </div>
      <div className=" flex space-x-4">
        <FaHandshakeSimple className="text-4xl" />
        <div>
          <h1 className="text-xl font-semibold">This User is a Super Seller</h1>
          <p>
            Super sellers are experienced, highly rated sellers who are committed to providing great
            service for customers.
          </p>
        </div>
      </div>
      <div className=" flex space-x-4">
        <FiCalendar className="text-4xl" />
        <div>
          <h1 className="text-xl font-semibold">Free cancellation before 14 days.</h1>
        </div>
      </div>
    </div>
  )
}

export default Description
