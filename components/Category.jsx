import React, { useState, useEffect } from 'react';
import { useRouter } from 'next/router';
import { FaComputer } from 'react-icons/fa6';
import { FaTshirt } from 'react-icons/fa';
import { MdSportsBasketball } from 'react-icons/md';
import { GiLipstick } from 'react-icons/gi';
import { PiSneakerFill } from 'react-icons/pi';
import { GiHealthNormal } from "react-icons/gi";

const Category = () => {
  const router = useRouter();
  const [activeCategory, setActiveCategory] = useState(null);

  useEffect(() => {
    // Set active category based on the current path
    const pathCategory = router.pathname.split('/')[2];
    if (pathCategory) {
      setActiveCategory(pathCategory);
    } else {
      setActiveCategory(null);
    }
  }, [router.pathname]);

  const handleCategoryClick = (category) => {
    if (activeCategory === category) {
      setActiveCategory(null);
      router.push('/'); // Navigate to the default view
    } else {
      setActiveCategory(category);
      router.push(`/category/${category}`); // Navigate to the selected category
    }
  };

  const isActive = (category) => activeCategory === category;

  return (
    <div className="flex justify-center space-x-5 sm:space-x-14 p-4 px-4 border-b-2 border-b-orange-200 text-orange-400 bg-gray-100 dark:bg-gray-900 dark:text-orange-400 animate-fadeIn">
      <div
        onClick={() => handleCategoryClick('electronics')}
        className={`flex flex-col items-center transition-transform transform hover:scale-110 hover:text-orange-800 dark:hover:text-orange-300 border-b-2 pb-2 cursor-pointer ${isActive('electronics') ? 'text-orange-800 dark:text-orange-300 border-orange-800 dark:border-orange-300' : 'border-transparent'}`}
      >
        <FaComputer className="text-3xl text-orange-400 dark:text-orange-400" />
        Electronics
      </div>
      <div
        onClick={() => handleCategoryClick('clothing')}
        className={`flex flex-col items-center transition-transform transform hover:scale-110 hover:text-orange-800 dark:hover:text-orange-300 border-b-2 pb-2 cursor-pointer ${isActive('clothing') ? 'text-orange-800 dark:text-orange-300 border-orange-800 dark:border-orange-300' : 'border-transparent'}`}
      >
        <FaTshirt className="text-3xl text-orange-400 dark:text-orange-400" />
        Clothing
      </div>
      <div
        onClick={() => handleCategoryClick('sports')}
        className={`flex flex-col items-center transition-transform transform hover:scale-110 hover:text-orange-800 dark:hover:text-orange-300 border-b-2 pb-2 cursor-pointer ${isActive('sports') ? 'text-orange-800 dark:text-orange-300 border-orange-800 dark:border-orange-300' : 'border-transparent'}`}
      >
        <MdSportsBasketball className="text-3xl text-orange-400 dark:text-orange-400" />
        Sports
      </div>
      <div
        onClick={() => handleCategoryClick('health')}
        className={`flex flex-col items-center transition-transform transform hover:scale-110 hover:text-orange-800 dark:hover:text-orange-300 border-b-2 pb-2 cursor-pointer ${isActive('health') ? 'text-orange-800 dark:text-orange-300 border-orange-800 dark:border-orange-300' : 'border-transparent'}`}
      >
        <GiHealthNormal className="text-3xl text-orange-400 dark:text-orange-400" />
        Health
      </div>
      <div
        onClick={() => handleCategoryClick('shoes')}
        className={`flex flex-col items-center transition-transform transform hover:scale-110 hover:text-orange-800 dark:hover:text-orange-300 border-b-2 pb-2 cursor-pointer ${isActive('shoes') ? 'text-orange-800 dark:text-orange-300 border-orange-800 dark:border-orange-300' : 'border-transparent'}`}
      >
        <PiSneakerFill className="text-3xl text-orange-400 dark:text-orange-400" />
        Shoes
      </div>
    </div>
  );
};

export default Category;
