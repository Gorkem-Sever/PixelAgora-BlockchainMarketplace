// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/utils/Counters.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';

contract DappMrkt is Ownable, ReentrancyGuard {
  using Counters for Counters.Counter;
  Counters.Counter private _totalProducts;

  struct ProductStruct {
    uint id;
    string name;
    string description;
    string location;
    string images;
    uint listings;
    uint price;
    string category; // Add category field
    address owner;
    bool purchased;
    bool deleted;
    uint timestamp;
  }

  struct PurchaseStruct {
    uint id;
    uint aid;
    address customer;
    uint date;
    uint quantity;
    uint price;
    bool checked;
    bool cancelled;
  }

  struct ReviewStruct {
    uint id;
    uint aid;
    string reviewText;
    uint rating;
    uint timestamp;
    address owner;
  }

  uint public securityFee;
  uint public taxPercent;

  mapping(uint => ProductStruct) products;
  mapping(uint => PurchaseStruct[]) purchasesOf;
  mapping(uint => ReviewStruct[]) reviewsOf;
  mapping(uint => bool) productExist;
  mapping(uint => uint[]) purchasedDates;
  mapping(uint => mapping(uint => bool)) isDatePurchased;
  mapping(address => mapping(uint => bool)) hasPurchased;

  constructor(uint _taxPercent, uint _securityFee) {
    taxPercent = _taxPercent;
    securityFee = _securityFee;
  }

  function createProduct(
    string memory name,
    string memory description,
    string memory location,
    string memory images,
    uint listings,
    uint price,
    string memory category // Add category parameter
  ) public {
    require(bytes(name).length > 0, 'Name cannot be empty');
    require(bytes(description).length > 0, 'Description cannot be empty');
    require(bytes(location).length > 0, 'Location cannot be empty');
    require(bytes(images).length > 0, 'Images cannot be empty');
    require(listings > 0, 'Listings cannot be zero');
    require(price > 0 ether, 'Price cannot be zero');
    require(bytes(category).length > 0, 'Category cannot be empty'); // Validate category

    _totalProducts.increment();
    ProductStruct memory lodge;
    lodge.id = _totalProducts.current();
    lodge.name = name;
    lodge.description = description;
    lodge.location = location;
    lodge.images = images;
    lodge.listings = listings;
    lodge.price = price;
    lodge.category = category; // Set category
    lodge.owner = msg.sender;
    lodge.timestamp = currentTime();

    productExist[lodge.id] = true;
    products[_totalProducts.current()] = lodge;
  }

  function updateProduct(
    uint id,
    string memory name,
    string memory description,
    string memory location,
    string memory images,
    uint listings,
    uint price,
    string memory category // Add category parameter
  ) public {
    require(productExist[id] == true, 'Product not found');
    require(msg.sender == products[id].owner, 'Unauthorized personnel, owner only');
    require(bytes(name).length > 0, 'Name cannot be empty');
    require(bytes(description).length > 0, 'Description cannot be empty');
    require(bytes(location).length > 0, 'Location cannot be empty');
    require(bytes(images).length > 0, 'Images cannot be empty');
    require(listings > 0, 'Listings cannot be zero');
    require(price > 0 ether, 'Price cannot be zero');
    require(bytes(category).length > 0, 'Category cannot be empty'); // Validate category

    ProductStruct memory lodge = products[id];
    lodge.name = name;
    lodge.description = description;
    lodge.location = location;
    lodge.images = images;
    lodge.listings = listings;
    lodge.price = price;
    lodge.category = category; // Set category

    products[id] = lodge;
  }

  function deleteProduct(uint id) public {
    require(productExist[id] == true, 'Product not found');
    require(products[id].owner == msg.sender, 'Unauthorized entity');

    productExist[id] = false;
    products[id].deleted = true;
  }

  function getProducts() public view returns (ProductStruct[] memory Products) {
    uint256 available;
    for (uint i = 1; i <= _totalProducts.current(); i++) {
      if (!products[i].deleted) available++;
    }

    Products = new ProductStruct[](available);

    uint256 index;
    for (uint i = 1; i <= _totalProducts.current(); i++) {
      if (!products[i].deleted) {
        Products[index++] = products[i];
      }
    }
  }

  function getProduct(uint id) public view returns (ProductStruct memory) {
    return products[id];
  }

  function buyProduct(uint aid, uint quantity, uint[] memory dates) public payable {
    require(productExist[aid], 'Product not found!');
    require(quantity > 0 && quantity <= products[aid].listings, 'Invalid quantity!');

    uint totalPrice = products[aid].price * quantity;
    uint totalCost = totalPrice + (totalPrice * securityFee) / 100;
    require(msg.value >= totalCost, 'Insufficient fund!');

    for (uint i = 0; i < quantity; i++) {
        PurchaseStruct memory purchase;
        purchase.aid = aid;
        purchase.id = purchasesOf[aid].length;
        purchase.customer = msg.sender;
        purchase.quantity = 1;  // Each purchase entry will have a quantity of 1
        purchase.price = products[aid].price;
        purchase.date = dates[i];
        purchasesOf[aid].push(purchase);

        isDatePurchased[aid][dates[i]] = true;
        purchasedDates[aid].push(dates[i]);
    }

    products[aid].listings -= quantity;
}


  function approveProduct(uint aid, uint purchaseId) public {
    PurchaseStruct memory purchase = purchasesOf[aid][purchaseId];
    require(msg.sender == purchase.customer, 'Unauthorized customer!');
    require(!purchase.checked, 'Product already checked on this date!');

    purchasesOf[aid][purchaseId].checked = true;
    uint fee = (purchase.price * securityFee) / 100;

    hasPurchased[msg.sender][aid] = true;

    payTo(products[aid].owner, (purchase.price));
    payTo(msg.sender, fee);
  }

  function refundPurchase(uint aid, uint purchaseId) public nonReentrant {
    PurchaseStruct memory purchase = purchasesOf[aid][purchaseId];
    require(!purchase.checked, 'Product already checked on this date!');
    require(isDatePurchased[aid][purchase.date], 'Did not purchase on this date!');

    if (msg.sender != owner()) {
      require(msg.sender == purchase.customer, 'Unauthorized customer!');
    }

    purchasesOf[aid][purchaseId].cancelled = true;
    isDatePurchased[aid][purchase.date] = false;

    // Safely remove the date from purchasedDates array
    uint length = purchasedDates[aid].length;
    for (uint i = 0; i < length; i++) {
        if (purchasedDates[aid][i] == purchase.date) {
            purchasedDates[aid][i] = purchasedDates[aid][length - 1];
            purchasedDates[aid].pop();
            break;
        }
    }

    uint fee = (purchase.price * securityFee) / 100;
    uint collateral = fee;

    payTo(products[aid].owner, collateral);
    payTo(msg.sender, purchase.price);
  }


  function getUnavailableDates(uint aid) public view returns (uint[] memory) {
    return purchasedDates[aid];
  }

  function getPurchases(uint aid) public view returns (PurchaseStruct[] memory) {
    return purchasesOf[aid];
  }

  function getQualifiedReviewers(uint aid) public view returns (address[] memory Customers) {
    uint256 available;
    for (uint i = 0; i < purchasesOf[aid].length; i++) {
      if (purchasesOf[aid][i].checked) available++;
    }

    Customers = new address[](available);

    uint256 index;
    for (uint i = 0; i < purchasesOf[aid].length; i++) {
      if (purchasesOf[aid][i].checked) {
        Customers[index++] = purchasesOf[aid][i].customer;
      }
    }
  }

  function getPurchase(uint aid, uint purchaseId) public view returns (PurchaseStruct memory) {
    return purchasesOf[aid][purchaseId];
  }

  function payTo(address to, uint256 amount) internal {
    (bool success, ) = payable(to).call{ value: amount }('');
    require(success);
  }

 function addReview(uint aid, string memory reviewText, uint rating) public {
    require(productExist[aid], 'Product not available');
    require(hasPurchased[msg.sender][aid], 'Purchase first before review');
    require(bytes(reviewText).length > 0, 'Review text cannot be empty');
    require(rating >= 1 && rating <= 5, 'Rating must be between 1 and 5');

    ReviewStruct memory review;

    review.aid = aid;
    review.id = reviewsOf[aid].length;
    review.reviewText = reviewText;
    review.rating = rating; // Include the rating
    review.timestamp = currentTime();
    review.owner = msg.sender;

    reviewsOf[aid].push(review);
}

  function getReviews(uint aid) public view returns (ReviewStruct[] memory) {
    return reviewsOf[aid];
  }

  function customerPurchased(uint productId) public view returns (bool) {
    return hasPurchased[msg.sender][productId];
  }

  function currentTime() internal view returns (uint256) {
    return (block.timestamp * 1000) + 1000;
  }
}
