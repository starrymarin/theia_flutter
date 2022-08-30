package io.flutter.plugins;

import java.util.ArrayList;
import java.util.List;

public class Test {
    Data dataTree = new Data("a");

    Test() {
        Data b = new Data("b");
        Data c = new Data("c");
        Data d = new Data("d");
        Data e = new Data("e");
        Data f = new Data("f");
        Data g = new Data("g");
        Data h = new Data("h");

        dataTree.children.add(b);
        dataTree.children.add(c);

        b.children.add(d);
        b.children.add(e);

        c.children.add(f);
        c.children.add(g);

        d.children.add(h);
    }

    void dataTreeToWidgetTree() {

    }

}

class Data {
    String name;
    List<Data> children = new ArrayList();

    Data(String name) {
        this.name = name;
    }
}

class Widget {
    String name;

    Widget(List<Widget> children) {
    }
}
