@JS()
library main2;

import 'package:customElementDemo/html.dart';
import 'package:js/js.dart';

class DartElement extends HtmlElement {
  DartElement() : _el = HtmlElement();

  final HtmlElement _el;

}


void main() {
  if (isDDC) defineDartElement('dart-el', allowInterop(() => DartElement.created()));
  else document.registerElement('dart-el', DartElement);

  var hello = document.body.append(Element.tag('dart-hello')) as JSCustomElement<HelloElement>;
  hello.asDart.sayHello();

  var goodbye = document.body.append(Element.tag('dart-goodbye')) as JSCustomElement<GoodbyeElement>;
  goodbye.asDart.sayGoodybe();

  document.body.append(Element.tag('dart-el'));
}

class DartElement extends HtmlElement {
  @override
  void attached() => appendHtml('<div>DartElement</div>');
}

@JS()
external void defineDartElement(String name, Function constructor);

// Hack to detect whether we are running in DDC or Dart2JS.
@JS(r'$dartLoader')
external Object get _$dartLoader;
final bool isDDC = _$dartLoader != null;