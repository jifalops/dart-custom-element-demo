@JS()
library main;

import 'dart:html' as html;
import 'package:js/js.dart';
import 'package:html5/html5.dart' as html5;

@JS('CustomElement')
abstract class JSCustomElement<T extends CustomElement> implements html.HtmlElement {
  T asDart;
  external void created(html.HtmlElement asDart);
}

typedef CustomElementConstructor = CustomElement Function(JSCustomElement e);

@JS('defineElement')
external void defineElement(String name, CustomElementConstructor constructor);

class CustomElement {
  JSCustomElement element;

  CustomElement(this.element) {
    element.asDart = this;
  }


  void connected() {}
  void disconnected() {}
}

class HelloElement extends CustomElement{
  HelloElement(JSCustomElement element) : super(element);

  void sayHello() {
    element.text = 'Hello from Dart!';
    element.style.color = '#0175C2';
  }
}

class GoodbyeElement extends CustomElement {
  GoodbyeElement(JSCustomElement element) : super(element);

  void sayGoodybe() {
    element.text = 'Goodbye from Dart!';
    element.style.color = '#0175C2';
  }
}

void main() {
  defineElement('dart-goodbye', allowInterop((e) => GoodbyeElement(e)));
  defineElement('dart-hello', allowInterop((e) => HelloElement(e)));

  if (isDDC) {
    // defineDartElement('dart-el', allowInterop(() => DartElement.created()));
  }
  else html.document.registerElement('dart-el', DartElement);

  var hello = html.document.body.append(html.Element.tag('dart-hello')) as JSCustomElement<HelloElement>;
  hello.asDart.sayHello();

  var goodbye = html.document.body.append(html.Element.tag('dart-goodbye')) as JSCustomElement<GoodbyeElement>;
  goodbye.asDart.sayGoodybe();

  html.document.body.append(html.Element.tag('dart-el'));
}

class DartElement extends html.HtmlElement {
  DartElement.created() : super.created() {
    html.JS();
  }
  @override
  void attached() => appendHtml('<div>DartElement</div>');
}

@JS()
external void defineDartElement(String name, Function constructor);

// Hack to detect whether we are running in DDC or Dart2JS.
@JS(r'$dartLoader')
external Object get _$dartLoader;
final bool isDDC = _$dartLoader != null;