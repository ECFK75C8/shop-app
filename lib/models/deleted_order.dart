import '../providers/order.dart';

class DeletedOrder{
  final int index;
  final OrderItem orderItem;

  DeletedOrder(this.index, this.orderItem);
}