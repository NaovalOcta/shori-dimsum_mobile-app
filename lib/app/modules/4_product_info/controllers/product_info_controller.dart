import 'package:get/get.dart';

class ImageGalleryClass extends GetxController {
  final RxInt currentPage = 0.obs; 

  void updatePage(int index) {
    currentPage.value = index;
  }
}

class ProductInfoController extends GetxController {
  ImageGalleryClass imageGalleryClass = ImageGalleryClass(); 
}
