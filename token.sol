//
//    _   ___   ______  _   _    _      _____ ___ _   _    _    _   _  ____ _____ 
//   | | | \ \ / /  _ \| | | |  / \    |  ___|_ _| \ | |  / \  | \ | |/ ___| ____|
//   | |_| |\ V /| |_) | |_| | / _ \   | |_   | ||  \| | / _ \ |  \| | |   |  _|  
//   |  _  | | | |  __/|  _  |/ ___ \  |  _|  | || |\  |/ ___ \| |\  | |___| |___ 
//   |_| |_| |_| |_|   |_| |_/_/   \_\ |_|   |___|_| \_/_/   \_\_| \_|\____|_____|
//                                                             
// 
// Website: https://www.hypha.finance
// Linktree: https://linktr.ee/hypha_finance
// 
// 

// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;


interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

interface IERC20Metadata is IERC20 {

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    function _contextSuffixLength() internal view virtual returns (uint256) {
        return 0;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    error OwnableUnauthorizedAccount(address account);

    error OwnableInvalidOwner(address owner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor(address initialOwner) {
        if (initialOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(initialOwner);
    }

    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    function _checkOwner() internal view virtual {
        if (owner() != _msgSender()) {
            revert OwnableUnauthorizedAccount(_msgSender());
        }
    }

    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}



contract HYPHA_Finance is Context, IERC20Metadata, Ownable {
  using SafeMath for uint256;

  mapping(address => uint256) private _balances;
  mapping(address => mapping(address => uint256)) private _allowances;

  address private ecosystemWallet = 0x9c201fA0a430234233309A554227B777C3134523;
  address private marketingWallet = 0xBE1C811bf63Dcd4AAF34D77233DCfeE027613e92;
  address private teamWallet = 0x1A5Cf3CEb60c2298132129418FFc7C80d241C4d4;
  address private stakingWallet = 0xAf322DAa4Ce62363bD427C7f682C0A8828F45407;
  address private presaleWallet = 0x2C23CE6340b5244050a87e31451561f7873D6D58;    
  address private incentivesWallet = 0x5cA3940d7fE909eC95D74416d17fF8375211Df2C;
  address private liquidityWallet = 0xCCb4DfB73cCeFe91B8d4f68bbDf22ef6B41975eF;

  string private _name = "Hypha Finance";
  string private _symbol = "HYPHA";
  uint8 private constant _decimals = 18;
  uint256 private _totalSupply = 0;

  uint256 private _HYPHASupply = 100_000_000_000 * 1e18;

  uint256 private ecosystemAmount = (_HYPHASupply.mul(20)).div(100);
  uint256 private marketingAmount = (_HYPHASupply.mul(3)).div(100);
  uint256 private teamAmount = (_HYPHASupply.mul(4)).div(100);
  uint256 private stakingAmount = (_HYPHASupply.mul(18)).div(100);
  uint256 private presaleAmount = (_HYPHASupply.mul(40)).div(100);
  uint256 private incentivesAmount = (_HYPHASupply.mul(3)).div(100);
  uint256 private liquidityAmount = (_HYPHASupply.mul(12)).div(100);

  uint x;



  event Received(address, uint);

   constructor() Ownable(msg.sender) {

    _mint(ecosystemWallet, ecosystemAmount);
    _mint(marketingWallet, marketingAmount);
    _mint(teamWallet, teamAmount);
    _mint(stakingWallet, stakingAmount);
    _mint(presaleWallet, presaleAmount);    
    _mint(incentivesWallet, incentivesAmount);
    _mint(liquidityWallet, liquidityAmount); 

  }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public pure returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function transfer(
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(
        address owner,
        address spender
    ) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(
        address spender,
        uint256 amount
    ) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()].sub(
                amount
            )
        );
        return true;
    }

    function increaseAllowance(
        address spender,
        uint256 addedValue
    ) public virtual returns (bool) {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].add(addedValue)
        );
        return true;
    }

    function decreaseAllowance(
        address spender,
        uint256 subtractedValue
    ) public virtual returns (bool) {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].sub(
                subtractedValue
            )
        );
        return true;
    }

    function claimStuckTokens(address token) external onlyOwner {
        require(token != address(this), "HYPHA: Owner cannot claim native tokens");
        if (token == address(0x0)) {
            payable(msg.sender).transfer(address(this).balance);
            return;
        }
        IERC20 ERC20token = IERC20(token);
        uint256 balance = ERC20token.balanceOf(address(this));
        ERC20token.transfer(msg.sender, balance);
    }

   function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "HYPHA: approve from the zero address");
        require(spender != address(0), "HYPHA: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(address from, address to, uint256 amount) private {
        require(from != address(0), "HYPHA: transfer from the zero address");
        require(to != address(0), "HYPHA: transfer to the zero address");
        require(amount > 0, "HYPHA: Amount must be greater than zero");

        _balances[from] = _balances[from].sub(
          amount
          );
        _balances[to] = _balances[to].add(amount);

        emit Transfer(from, to, amount);
    }

  function _mint(address account, uint256 amount) internal virtual {
    require(account != address(0), "HYPHA: mint to the zero address");

    _totalSupply += amount;
    _balances[account] += amount;
    emit Transfer(address(0), account, amount);
  }

  receive() external payable {
    emit Received(msg.sender, msg.value);
  }

  fallback() external { x = 1; }

}

library SafeMath {

  function mul(uint256 a, uint256 b) internal pure returns (uint256) {

    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b);

    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b > 0); // Solidity only automatically asserts when dividing by 0
    uint256 c = a / b;

    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b <= a);
    uint256 c = a - b;

    return c;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a);

    return c;
  }

  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b != 0);
    return a % b;
  }
}