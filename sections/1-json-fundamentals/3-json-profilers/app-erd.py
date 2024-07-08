import configparser
import json
import yaml
import xmltodict
import urllib.parse
import streamlit as st
from io import StringIO

# ==========================================================================
class Config:
    themes = {}
    theme = None

    def __new__(cls):
        raise TypeError("This is a static class and cannot be instantiated.")
    
    @classmethod
    def loadThemes(cls):
        parser = configparser.ConfigParser()
        parser.read("themes.conf")
        cls.themes = {}
        for section in parser.sections():
            cls.themes[section] = Theme(
                parser.get(section, "color"),
                parser.get(section, "fillcolor"),
                parser.get(section, "fillcolorC"),
                parser.get(section, "bgcolor"),
                parser.get(section, "icolor"),
                parser.get(section, "tcolor"),
                parser.get(section, "style"),
                parser.get(section, "shape"),
                parser.get(section, "pencolor"),
                parser.get(section, "penwidth"))
        return cls.themes

class Theme:
    def __init__(self, color, fillcolor, fillcolorC,
            bgcolor, icolor, tcolor, style, shape, pencolor, penwidth):
        self.color = color
        self.fillcolor = fillcolor
        self.fillcolorC = fillcolorC
        self.bgcolor = bgcolor
        self.icolor = icolor
        self.tcolor = tcolor
        self.style = style
        self.shape = shape
        self.pencolor = pencolor
        self.penwidth = penwidth

# ==========================================================================
class JsonManager:
    obj_id = 1

    def __new__(cls):
        raise TypeError("This is a static class and cannot be instantiated.")

    @classmethod
    def inferSchema(cls, data) -> str:     
        cls.obj_id = 1
        return Obj(data) if isinstance(data, dict) else Arr(data)

    @classmethod
    def getComma(cls, last) -> str: return "" if last else ","

    @classmethod
    def getIndent(cls, level) -> str: return "   " * level

# ==========================================================================
class Val:
    def __init__(self, val, level=0) -> None:
        self.level = level
        self.val = val

        if val is None:
            self.type = "null"; self.val = 'null'
        elif isinstance(val, bool):
            self.type = "bool"; self.val = str(self.val).lower()
        elif isinstance(val, (int, float)):
            self.type = "number"
        elif isinstance(val, list):
            self.type = "array"
            self.val = Arr(val, level)
        elif isinstance(val, dict):
            self.type = "object"
            self.val = Obj(val, level)
        else:
            self.type = "string"
            v = str(self.val).replace('"', '\\"')
            self.val = f'"{v}"'

        self.vals = []
        self.addValue(val)

    def isPrimitive(self):
        return self.type not in ["array", "object"]

    def addValue(self, val):
        if self.isPrimitive():
            if val not in self.vals:
                self.vals.append(val)
        elif self.type == "array":
            for x in val:
                if x not in self.vals:
                    self.vals.append(x)

    def _dumpVals(self):
        return ''
    
    def dump(self, last=True, lastVal=False):
        if self.isPrimitive():
            s = "" if last else ", "
            return f'"{self.type}"{s}'
        else:
            v = self.val.dump(last, lastVal)
            if lastVal or v.startswith("[ ]") or v.startswith("{ }"):
                return v
            else:
                return f'\n{v}'

# ==========================================================================
class Prop:
    def __init__(self, key, val, level=0) -> None:
        self.level = level
        self.key = key
        self.req = True
        self.count = 1
        self.val = Val(val, level)

    def getName(self):
        req = "" if self.req else "*"
        return f'"{self.key}{req}"'

    def dumpProp(self, last=True, lastVal=False):
        return f'{self.getName()}: {self.val.dump(last, lastVal)}'
    
    def dump(self, last=True, lastVal=False):
        suffix = '' if self.val.type == "object" else '\n'
        if not lastVal:
            lastVal = (self.val.type == "array"
                and (self.val.val.hasPrimitives() or self.val.val.hasSingleProp()))
        return f'{JsonManager.getIndent(self.level)}{self.dumpProp(last, lastVal)}{suffix}'

# ==========================================================================
class Obj:
    def __init__(self, obj, level=0) -> None:
        self.level = level
        self.name = f"n{JsonManager.obj_id}"
        JsonManager.obj_id += 1
        self.props = {}
        for key in obj: self.props[key] = Prop(key, obj[key], level+1)

    def hasSingleProp(self):
        if len(self.props) != 1: return False
        keys = list(self.props.keys())
        return self.props[keys[0]].val.isPrimitive()
    
    def dump(self, last=True, lastVal=False):
        comma = JsonManager.getComma(last)
        keys = list(self.props.keys())
        if len(keys) == 0:
            return f'{{ }}{comma}'
        else:
            prop = self.props[keys[0]]
            if lastVal:
                return f'{{ {prop.dumpProp(last, lastVal)} }}'
            if self.hasSingleProp():
                return f'{JsonManager.getIndent(self.level)}{{ {prop.dumpProp(last, lastVal)} }}\n'

        s = f'{JsonManager.getIndent(self.level)}{{\n'
        for key in self.props: s += self.props[key].dump(key is keys[-1])
        s += f'{JsonManager.getIndent(self.level)}}}{comma}\n'
        return s

# ==========================================================================
class Arr:
    def __init__(self, arr, level=0) -> None:
        self.level = level
        self.objs = []

        for elem in arr:
            if isinstance(elem, list):
                self.objs.append(Arr(elem, level+1))
            elif not isinstance(elem, dict):
                self.objs.append(Val(elem, level+1))
            elif len(self.objs) == 0:
                self.objs.append(Obj(elem, level+1))
            else:
                self._processArrObj(elem, level)

    def _processArrObj(self, elem, level):
        self._updateObject(elem, level)

    def _hasSameKeys(self, elem):
        for inst in self.objs:
            if self._hasSameKeysInst(elem, inst):
                return inst
        return None

    def _hasSameKeysInst(self, elem, inst):
        for key in elem:
            if key not in inst.props: return False
        for key in inst.props:
            if key not in elem: return False
        return True

    def _updateObject(self, elem, level):
        inst = self.objs[0]
        for key in inst.props:
            if key not in elem:
                inst.props[key].req = False
            else:
                inst.props[key].val.addValue(elem[key])
                inst.props[key].count += 1
        for key in elem:
            if key not in inst.props:
                inst.props[key] = Prop(key, elem[key], level+2)
                inst.props[key].req = False

    def hasPrimitives(self):
        return (len(self.objs) > 0
            and isinstance(self.objs[0], Val)
            and self.objs[0].isPrimitive())
    
    def getPrimitiveType(self):
        return "array" if not self.hasPrimitives() else self.objs[0].type
    
    def hasSingleProp(self):
        return (len(self.objs) == 1
            and isinstance(self.objs[0], Obj)
            and self.objs[0].hasSingleProp())

    def dump(self, last=True, lastVal=False):
        comma = JsonManager.getComma(last)
        if len(self.objs) == 0:
            return f'[ ]{comma}'
        elif self.hasPrimitives():
            return f'[ {self.objs[0].dump(True, True)} ]{comma}'
        elif self.hasSingleProp():
            return f'[{self.objs[0].dump(True, True)}]{comma}'

        s = f'{JsonManager.getIndent(self.level)}[\n'
        for obj in self.objs:
            d = obj.dump(obj is self.objs[-1])
            s += d if not isinstance(obj, Val) else f'{JsonManager.getIndent(obj.level)}{d}\n'
        s += f'{JsonManager.getIndent(self.level)}]{comma}'
        return s

# ==========================================================================
class ERDManager:
    tables = {}
    obj = None

    def __new__(cls):
        raise TypeError("This is a static class and cannot be instantiated.")

    @classmethod
    def getEntities(cls, obj):
        cls.tables = {}
        cls.obj = obj
        if isinstance(obj, Arr):
            for o in obj.objs:
                cls._getTable(o, True)
        else:
            cls._getTable(obj, True)
        cls._removeDuplTables()
        return cls.tables

    @classmethod    
    def getTopObjLabel(cls):
        return "JSON_ARRAY" if isinstance(cls.obj, Arr) else "JSON_OBJECT"

    @classmethod
    def _getTable(cls, obj, isTop=False):
        if obj.name in cls.tables:
            return cls.tables[obj.name]

        table = Table(obj, obj.name)
        cls.tables[obj.name] = table
        table.isTop = isTop
        for key in obj.props:
            prop = obj.props[key]
            col = Column(table, prop, prop.key)
            table.columns.append(col)
            col.nullable = not prop.req
            col.count = prop.count

            if isinstance(prop.val.val, Obj):
                col.obj = cls._getTable(prop.val.val)
            elif not isinstance(prop.val.val, Arr):
                col.datatype = prop.val.type
            elif prop.val.val.hasPrimitives():
                col.datatype = f"{prop.val.val.getPrimitiveType()}[]"
            else:
                for obj1 in prop.val.val.objs:
                    col.arr.append(cls._getTable(obj1))
        return table

    @classmethod
    def getEmptyDotShape(cls, label):
        return (f'  {label} [fillcolor="{Config.theme.fillcolorC}" color="{Config.theme.color}"'
            + ' penwidth="1" shape="point" label=" "]\n')

    @classmethod
    def createGraph(cls):
        s = ('digraph {\n'
            + '  graph [ rankdir="RL" bgcolor="#ffffff" ]\n'
            + f'  node [ style="filled" shape="{Config.theme.shape}" gradientangle="180" ]\n'
            + '  edge [ arrowhead="none" arrowtail="normal" dir="both" ]\n\n'
            + cls.getEmptyDotShape(cls.getTopObjLabel()))

        for name in cls.tables: s += cls.tables[name].getDotShape()
        s += "\n"
        for name in cls.tables: s += cls.tables[name].getDotLinks()
        s += "}\n"
        return s
    
    @classmethod
    def _removeDuplTables(cls):
        while True:
            table1, table2 = cls._findSimilar()
            if table1 is None: return
            cls._replaceTable(table1, table2)

    @classmethod
    def _findSimilar(cls):
        for key1 in cls.tables:
            table1 = cls.tables[key1]
            for key2 in cls.tables:
                table2 = cls.tables[key2]
                if table1 != table2 and table1.isSimilarWith(table2):
                    return table1, table2
        return None, None

    @classmethod
    def _replaceTable(cls, table1, table2):
        for key in cls.tables:
            table = cls.tables[key]
            for col in table.columns:
                if col.obj is not None and col.obj == table1:
                    col.obj = table2
                elif len(col.arr) > 0:
                    for obj in col.arr:
                        if obj == table1:
                            col.arr.remove(table1)
                            col.arr.append(table2)
        del cls.tables[table1.name]

# ==========================================================================
class Column:
    def __init__(self, table, prop, name):
        self.table = table
        self.prop = prop
        self.name = name
        self.count = 0
        self.nullable = True

        self.datatype = None        # string, string[]
        self.obj = None             # Table
        self.arr = []               # [Table, ...] <-- array of array?

    def getName(self):
        name = self.name
        if self.nullable: name = f"{name}*"
        if len(self.arr) > 0: name += "[]"
        return name

    def isSimilarWith(self, col) -> bool:
        if col.nullable != self.nullable: return False
        if col.datatype is not None and self.datatype is not None:
            return col.datatype == self.datatype
        if col.obj is not None and self.obj is not None:
            return col.obj == self.obj
        if len(col.arr) > 0 and len(self.arr) > 0:
            for type in self.arr:
                if type not in col.arr: return False
            for type in col.arr:
                if type not in self.arr: return False
        return True

# ==========================================================================
class Table:
    def __init__(self, obj, name):
        self.obj = obj
        self.name = name
        self.isTop = False
        
        self.columns = []           # list of all columns

    def getColumn(self, name):
        for column in self.columns:
            if column.name == name:
                return column
        return None

    def isSimilarWith(self, table) -> bool:
        if len(self.columns) != len(table.columns): return False
        for col in self.columns:
            other = table.getColumn(col.name)
            if other is None or not col.isSimilarWith(other): return False
        for col in table.columns:
            other = self.getColumn(col.name)
            if other is None or not col.isSimilarWith(other): return False
        return True

    def getDotShape(self):
        s = self.getDotColumns()
        if len(s) == 0:
            return ERDManager.getEmptyDotShape(self.name)
        return (f'  {self.name} [\n'
            + f'    fillcolor="{Config.theme.fillcolorC}" color="{Config.theme.color}" penwidth="1"\n'
            + f'    label=<<table style="{Config.theme.style}" border="0" cellborder="0" cellspacing="0" cellpadding="1">\n'
            + s
            + f'    </table>>\n  ]\n')

    def getDotColumns(self):
        s = ""
        for col in self.columns:
            if col.datatype is not None:
                s += (f'      <tr><td align="left"><font color="{Config.theme.icolor}">{col.getName()}</font></td>\n'
                    + f'      <td align="left"><font color="{Config.theme.icolor}">{col.datatype}</font></td></tr>\n')
        return s

    def getTopDotLink(self):
        if not self.isTop: return ""
        top_label = ERDManager.getTopObjLabel()
        array = "" if top_label == "JSON_OBJECT" else ' arrowtail="crow" style="dashed"'
        return f'  {self.name} -> {top_label} [ penwidth="{Config.theme.penwidth}" color="{Config.theme.pencolor}"{array} ]\n'

    def getDotLinks(self):
        s = "" if not self.isTop else self.getTopDotLink()
        for col in self.columns:
            if col.datatype is None:
                dashed = "" if not col.nullable else ' style="dashed"'
                label = f' label=<<i>{col.getName()}</i>>'
                if col.obj is not None:
                    s += (f'  {col.obj.name} -> {self.name}'
                        + f' [ penwidth="{Config.theme.penwidth}" color="{Config.theme.pencolor}"{dashed}{label} ]\n')
                else:
                    for obj in col.arr:
                        s += (f'  {obj.name} -> {self.name}'
                            + f' [ penwidth="{Config.theme.penwidth}" color="{Config.theme.pencolor}"{dashed}{label} arrowtail="crow" ]\n')
        return s


def loadFile():
    filename = "test.json" if uploaded_file is None else uploaded_file.name
    filename = filename.lower()
    if 'filename' not in st.session_state \
        or st.session_state.filename != filename:
        if uploaded_file is not None:
            bytes = uploaded_file.getvalue()
            raw = StringIO(bytes.decode("utf-8")).read()
        else:
            with open(filename) as f:
                raw = f.read()

        if filename.endswith(".yml") or filename.endswith(".yaml"):
            text = json.dumps(yaml.safe_load(raw), indent=3)
            filetype = "yaml"
        elif filename.endswith(".xml"):
            text = json.dumps(xmltodict.parse(raw), indent=3)
            filetype = "xmlDoc"
        else:
            text = raw
            filetype = "json"

        data = json.loads(text)
        if not isinstance(data, dict) and not isinstance(data, list):
            st.error("Bad Format!")
            st.stop()
        
        st.session_state['filename'] = filename
        st.session_state['filetype'] = filetype
        st.session_state["raw"] = raw
        st.session_state["text"] = text
        st.session_state["data"] = data

    filetype = st.session_state.filetype
    raw = st.session_state.raw
    text = st.session_state.text
    data = st.session_state.data
    return raw, text, data

def renderFile():
    _, text, data = loadFile()
    objects = JsonManager.inferSchema(data)
    ERDManager.getEntities(objects)

    tabSource, tabERD = st.tabs(["JSON Source File", "Inferred Object Model"])

    with tabSource:
        st.caption("This is your eventually converted and formatted source file, in JSON.")
        st.code(text, language="json", line_numbers=True)

    with tabERD:
        st.caption("This is your infered object model, with GraphViz.")
        st.graphviz_chart(ERDManager.createGraph(), use_container_width=True)


st.set_page_config(layout="wide")
st.title("JSON Data Profiler")
st.caption("Upload a JSON, YAML or XML data file, and get its inferred schema and a Entity-Relationship diagram.")

uploaded_file = st.sidebar.file_uploader(
    "Upload a JSON, XML, or YML file", accept_multiple_files=False)

Config.loadThemes()
themeName = st.sidebar.selectbox('Theme:', tuple(Config.themes.keys()), index=0,
    help="Color theme for the ERD")
Config.theme = Config.themes[themeName]

renderFile()
