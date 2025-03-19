
// Inicializa una nueva instancia de tipo 'TabManager'.
// 'container' -> elemento que contendrá los lengüetas.
// 'parentManager' -> el manejador padre de éste.
function TabManager(container, parentManager)
{
	this.parentManager = parentManager;
	this.container = container;
	window.tabManager = this;
}


var ProcessTabBuilder =
{
    InitializeContainer: function (container) {
        ul = document.createElement("UL");
        ul.className = "tabs";

        var add = document.createElement("LI");
        add.className = "add";
        add.innerHTML = "<a href='#' title='Nueva Tarea (F2)'><span class='before'></span>Nuevo</a>";

        var me = self;
        add.onclick = function (e) {
            top.openWorkSpace();
        }

        ul.appendChild(add);
        container.appendChild(ul);

        container.AddTab = function (li) {
            ul.insertBefore(li, add);
        }

        container.RemoveTab = function (li) {
            ul.removeChild(li);
        }
    },

    InitializeTab: function (li, index) {
        var me = this;
        li.onclick = function (e) {
            procManager.goTo(li.CurrentIndex());
        }

        li.innerHTML = "<a href='#'>Nueva Tarea</a><div class='close' title='Cerrar (F3)'></div>";

        var div = li.children[1];
        div.onclick = function (e) {
            top.closeWorkSpace(false);
            if (e)
                e.cancelBubble = true;
        }

        procManager.goTo(index);
    }
};


var StepTabBuilder =
{
    InitializeContainer: function (container) {
        ul = document.createElement("UL");
        ul.className = "tabs";

        container.appendChild(ul);

        container.AddTab = function (li) {
            ul.appendChild(li);
        }

        container.RemoveTab = function (li) {
            ul.removeChild(li);
        }
    },

    InitializeTab: function (li, index) {
        var me = this;
        li.onclick = function (e) {
            sManager.goTo(li.CurrentIndex());
        }

        var arr = "";

        if (index > 0)
            li.innerHTML = "<span class='nextTab'></span> <a href='#'> &nbsp; </a>";
        else
            li.innerHTML = "<a href='#'> &nbsp; </a>";

        //StepManager.prototype.goTo(index);
		sManager.goTo(index);
    }
};

var TabManager =
{
    _container: null,
    _selected: -1,
    _elements: new Array(),
    _builder: null,

    _el: function (name, index) {
        return this._elements[index].getElementsByTagName(name)[0];
    },

    _li: function (index) {
        return this._elements[index];
    },

    _a: function (index) {
        return this._el("A", index);
    },

    Initialize: function (container, builder) {
        // Inicializa el objeto "TabManager" que sirve para hacer manejar la lista de tabs
        //   "container" -> elemento html base que contendra' las leng'u'etas.
        this._container = container;
        this._builder = builder;

        builder.InitializeContainer(container);
    },

    select: function (index) {
        // Pinta la leng'u'eta indicada.
        if (this._selected != -1) {
            this._li(this._selected).className = '';
        }

        this._selected = index;

        if (index != -1) {
			this._li(index).className = "active";
        }
    },

    enqueueTab: function () {
        var li = document.createElement("LI");

        var me = this;
        li.CurrentIndex = function () {
            for (var i = 0; i < me._elements.length; i++) {
                if (me._elements[i] == li) {
                    return i;
                }
            }

            return 0;
        }

        var index = this._elements.length;

        this._builder.InitializeTab(li, index);

        this._container.AddTab(li);
        this._elements.push(li);

        this.select(index);
    },

    adviceAt: function (index) {
        // Muestra un aviso sobre la leng'u'eta indicada.
        var count = 0;

        var li = this._li(index);
        li.className = "advice";

        var timeout = setInterval(function () {
            count++;
            if (count == 7 || li.className == "active") {
                clearTimeout(timeout);
            }
            else {
                li.className = count % 2 == 0 ? "advice" : "";
            }
        }, 200);
    },

    removeTabAt: function (index) {
        // Elmina un leng'u'eta de una posicio'n dada.
        //   "index" -> i'nidce del leng'u'eta a remover.
        this._container.RemoveTab(this._elements[index]);
        this._elements.splice(index, 1);

        if (this._selected == index) {
            if (index == this._elements.length) {
                this._selected--;
            }

            this.select(this._selected);
        }
        else if (this._selected > index) {
            this._selected--;
        }
    },

    truncAt: function (index) {
        // Trunca la lista de leng'u'etas desde la posicio'n indicada.
        //   "index" -> posicio'n en la cual se truncara'.
        for (var i = this._elements.length - 1; i >= index; i--) {
            this.removeTabAt(i);
        }
    },

    setCaption: function (index, caption) {
        // Define la etiqueta de la posicio'n indicada y la selecciona.
        //   "index" -> i'ndice del leng'u'eta a seleccionar.
        //   "caption" -> etiqueta de la leng'u'eta.
        this._a(index).innerText = caption;
    },

    reset: function () {
        // Vaci'a el manejador de leng'u'etas y lo deja pronto para ser reutilizado.
        this._container.innerHTML = "";
        this._selected = -1;
        this._elements = new Array();
        this._builder.InitializeContainer(this._container)
    },

    hide: function () {
        // Se utiliza solamente desde el "StepManager" ya que que el "ProcessManager" nunca tiene necesidad de ocultar sus leng'u'etas
        this._container.style.visibility = "hidden";
    },

    show: function () {
        this.BeforeShow();

        // Se utiliza solamente desde el "StepManager" ya que que el "ProcessManager" nunca tiene necesidad de ocultar sus leng'u'etas
        this._container.style.visibility = "visible";
    },

    BeforeShow: function () {
        // No hace nada por defecto, se define un comportamiento especi'fico en "processIndex.html"
    },

    NoDisplay: function () {
        // No hace nada por defecto, se define un comporamiento especi'fico en "processIndex.html"
    }
};
// Popiedades comunes a todos los objetos de tipo 'TabManager'

