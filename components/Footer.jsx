import { FiGlobe } from 'react-icons/fi';
import { FaTwitter, FaLinkedin, FaInstagram } from "react-icons/fa";
import Link from 'next/link';

const Footer = () => {
  return (
    <div className="fixed left-0 right-0 bottom-0 px-6 sm:px-20 py-4 sm:py-6 flex flex-col sm:flex-row justify-between items-center bg-gradient-to-r from-white via-white to-white dark:from-gray-800 dark:via-gray-700 dark:to-gray-600 border-t-2 border-t-orange-400 dark:border-t-gray-700 text-black dark:text-gray-200 z-50">
      <div className="flex flex-col sm:flex-row items-center space-y-2 sm:space-y-0 sm:space-x-10 text-center sm:text-left">
        <p className="text-lg font-bold">
        PixelAgora &copy;{new Date().getFullYear()}
        </p>
        <div className="flex space-x-4">
          <Link href="/info/aboutus">
            <span className="hover:underline cursor-pointer">About Us</span>
          </Link>
          <Link href="/info/contact">
            <span className="hover:underline cursor-pointer">Contact</span>
          </Link>
          <Link href="/info/termsofservice">
            <span className="hover:underline cursor-pointer">Terms of Service</span>
          </Link>
          <Link href="/info/privacypolicy">
            <span className="hover:underline cursor-pointer">Privacy Policy</span>
          </Link>
        </div>
      </div>
      <div className="flex items-center space-x-4 text-lg font-semibold">
        <SocialLinks />
      </div>
    </div>
  );
};

const SocialLinks = () => {
  return (
    <div className="flex items-center space-x-4">
      <Link href={'https://twitter.com'} legacyBehavior>
        <a target="_blank" rel="noopener noreferrer">
          <FaTwitter className="text-orange-400 dark:text-orange-400 hover:text-orange-500 transition duration-150 ease-in-out" size={24} />
        </a>
      </Link>
      <Link href={'https://www.linkedin.com'} legacyBehavior>
        <a target="_blank" rel="noopener noreferrer">
          <FaLinkedin className="text-orange-400 dark:text-orange-400 hover:text-orange-500 transition duration-150 ease-in-out" size={24} />
        </a>
      </Link>
      <Link href={'https://www.instagram.com'} legacyBehavior>
        <a target="_blank" rel="noopener noreferrer">
          <FaInstagram className="text-orange-400 dark:text-orange-400 hover:text-orange-500 transition duration-150 ease-in-out" size={24} />
        </a>
      </Link>
    </div>
  );
}

export default Footer;
