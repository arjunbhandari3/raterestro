import 'package:scoped_model/scoped_model.dart';
import 'package:raterestro/src/models/food.dart';
import 'package:raterestro/src/models/cart.dart';

class CartScopedModel extends Model {
  int _quantity = 1;
  double _subTotal;

  List<Cart> _cartList = [];
   
  List<Cart> get cartItems => _cartList;

  int get quantity => _quantity;

  void incrementQuantity() {
    ++_quantity;
    notifyListeners();
  }

  void decrementQuantity() {
    if (_quantity > 1) {
      --_quantity;
    }
    notifyListeners();
  }

  void addToCart(Food food, int quantity) {
    _quantity = 1;
    _cartList.add(Cart(food,quantity));
    notifyListeners();
  }

  String getCartDetails() {
    var total = 0;
    _cartList.forEach((item) {
        print(item.food.price.runtimeType);
        print(item.food.price);
    });
    return  '${_cartList.length}';
  }
  
  double getCartTotal() {
    double total = 0.0;
    _cartList.forEach((item) {
    print(item.food.price.runtimeType);
    print(item.food.price);
    total += item.food.price * item.quantity;
    });
    return total;
  }

  void updateItemCount(int index, bool increase) {
    if (increase)
      _cartList[index].quantity += 1;
    else
      _cartList[index].quantity -= 1;

    if (_cartList[index].quantity == 0) {
      _cartList.removeAt(index);
    }
    notifyListeners();
  }

  void clearCart() {
    _cartList = [];
    notifyListeners();
  }
}
