/**
 * jpylyzerResultTree: a namespace container for functions to create a jsTree tree-view
 * for jpylyzer output.
 */
var jpylyzerResultTree = {};

/**
 * Creates a unordered list from the output xml of jpylyzer; this can be passed to jsTree.
 *
 * @param {String} xml A jquery dom object representing xml content.
 * @param {object} uniqueness_guard A memory of all element tagNames to guarantee uniqueness
 */
jpylyzerResultTree.createResultTree = function createResultTree(xml, uniqueness_guard) {
    var tree = "";
    jQuery(xml).each(function (i, elem) {
        var tagName = tagNameToDisplay = elem.tagName.toLowerCase();
        if (uniqueness_guard.hasOwnProperty(tagName)) {
            tagName += "_";
        }
        uniqueness_guard[tagName] = null; // add to 'memory'
        if (i === 0) {
            tree += "<ul>";
        }
        if (tagName === "jpylyzer") {
            tagNameToDisplay = "<span class='check-results'>Results</span>";
        }
        tree += "<li id='jpylyzer_" + tagName + "'>" + tagNameToDisplay;
        if (elem.attributes.length > 0 && tagName === tagNameToDisplay) {
            var attr, a;
            for (a = 0; a < elem.attributes.length; a++) {
                attr = elem.attributes.item(a);
                tree += " " + attr.name + "=" + attr.value;
            }
        }
        if (elem.children.length > 0) {
            tree += createResultTree(elem.children, uniqueness_guard);
        } else if (elem.textContent !== "") {
            var clazz = "elem-value";
            if (elem.textContent === "False") {
                clazz += " failed";
            }
            tree += ": <span class='" + clazz + "'>" + elem.textContent + "</span>";
        }
        tree += "</li>";
        if (i === jQuery(xml).size() - 1) {
            tree +=  "</ul>";
        }
    });
    console.log(tree);
    return tree;
};

jpylyzerResultTree.showAll = function (xml) {
    // the first item of the tree is a comment node which we want to skip
    return this.createResultTree(jQuery(xml)[1], {});
};

jpylyzerResultTree.showProperties = function (xml) {
        return this.createResultTree(jQuery(xml).find('properties'), {});
};

/**
 * Arranges the tree so that a few child nodes are open and one ('tests')
 * has all sub-elements open.
 *
 * @param {String} nodeName A dom-id to be used by jQuery to find the tree.
 */
jpylyzerResultTree.arrangeTree = function (nodeName) {
    jQuery(nodeName).jstree();
    var to_open = ['toolinfo', 'fileinfo', 'properties'];

    for (var node in to_open) {
        jQuery(nodeName).jstree().select_node("jpylyzer_" + to_open[node]);
        jQuery(nodeName).jstree().deselect_node("jpylyzer_" + to_open[node]);
        jQuery(nodeName).jstree().open_node("jpylyzer_" + to_open[node]);
    }
    jQuery(nodeName).jstree().select_node("jpylyzer_tests");
    jQuery(nodeName).jstree().deselect_node("jpylyzer_tests");
    jQuery(nodeName).jstree().open_all("jpylyzer_tests");
};

jpylyzerResultTree.tidyUp = function (nodeName) {
    // if there is a running instance of jstree: destroy
    if (jQuery(nodeName).jstree() !== "undefined") {
        jQuery(nodeName).jstree().destroy();
    }
};

