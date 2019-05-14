final baseUrl = 'https://fioriguate.com/api/';

class ApiMethods{
  login(){
    return baseUrl + 'loginapp';
  }

  getOrderByCode(){
    return baseUrl + 'datospedido';
  }

  getOrdersByType(String userId, String type){
    return baseUrl + 'pedidosrepartidor?repartidorId=$userId&tipo=$type';
  }

  saveOrderDelivered(){
    return baseUrl + 'guardardatosentrega';
  }
}
