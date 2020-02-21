require 'parslet'
require 'date'
require "#{ENV["BITTNDIR"]}/lib/debugmsgs/main.rb"

# ----- Sample ---------- #
# class ****Node          #
#   def initialize(data)  #
#   @data = data          #
#   end                   #
#   def call()            #
#   end                   #
# end                     #
#                         #
# class ****Node          #
#   def initialize(data)  #
#     @data = data        #
#   end                   #
#   def exec()            #
#   end                   #
# end                     #
# ----------------------- #

$var = {}


class BittnTestLang2Parser < Parslet::Parser
  idens = ["print","date"]
  root(:code)
  rule(:space){ str(" ") }
  rule(:spaces){ space.repeat(1) }
  rule(:space?){ spaces.repeat(0) }
  rule(:return_mark){ str("\n") }
  rule(:returns){ return_mark.repeat(1) }
  rule(:return?){ returns.maybe }
  rule(:sprt?){ (return_mark | space).repeat(0)}
  rule(:sprt){ (return_mark | space).repeat(1)}
  rule(:chars){ str("a") | str("b") | str("c") | str("d") | str("e") | str("f") | str("g") | str("h") | str("i") | str("j") | str("k") | str("l") | str("m") | str("n") | str("o") | str("p") | str("q") | str("r") | str("s") | str("t") | str("u") | str("v") | str("w") | str("x") | str("y") | str("z") | str("A") | str("B") | str("C") | str("D") | str("E") | str("F") | str("G") | str("H") | str("I") | str("J") | str("K") | str("L") | str("M") | str("N") | str("O") | str("P") | str("Q") | str("R") | str("S") | str("T") | str("U") | str("V") | str("W") | str("X") | str("Y") | str("Z") | str("0") | str("1") | str("2") | str("3") | str("4") | str("5") | str("6") | str("7") | str("8") | str("9") | str(" ") | str("!") | str("\\\"") | str("#") | str("$") | str("%") | str("&") | str("\\'") | str("(") | str(")") | str("-") | str("^") | str("@") | str("[") | str(";") | str(":") | str("]") | str(",") | str(".") | str("/") | str("\\\\") | str("~") | str("|") | str("`") | str("{") | str("+") | str("*") | str("}") | str("<") | str(">") | str("?") | str("_") | str("\\n") | str("\t") }

  rule(:string) {
    str("\"") >> chars.repeat.as(:chars) >> str("\"")
  }

  rule(:var) {
    match("[a-z]") >> match("[a-zA-Z1234567890]").repeat(0)
  }

  rule(:nvar) {
    match("[a-z]") >> match("[a-zA-Z1234567890]").repeat(0)
  }

  rule(:integer) {
    match("[0-9]").repeat(1)
  }

  rule(:code) {
    (line.as(:line) | return_mark).repeat(0).as(:code)
  }

  rule(:line) {
    assign.as(:assign) | func.as(:func) | value.as(:value)
  }

  rule(:func) {
    idens.map{|f| str(f)}.inject(:|).as(:idens) >> param
  }

  rule(:param){
    str("(") >> sprt? >> ( sprt? >> line.as(:param) >> sprt? >> (sprt? >> str(",") >> sprt? >> line.as(:param) >> sprt?).repeat(0)).maybe >> sprt? >> str(")")
  }

  rule(:assign){
    var.as(:nvar) >> space? >> str("=") >> space? >> value.as(:value)
  }


  rule(:value){
    string.as(:string) | integer.as(:integer) | var.as(:var)
  }
end

# np = BittnTestLang2Parser.new
# # p np.code.parse <<CODE
# # a = "aiueo"
# # CODE
# p np.line.parse %(a = "aiueo")
# exit(0)

# "\u0004\bo:\tLang\v:\n@nameI\"\u0013BittnTestLang2\u0006:\u0006ET:\r@versionU:\u0011Gem::Version[\u0006I\"\u00120.0.0.pre.dev\u0006;\aT:\f@parser\"\u001F\u0004\bo:\u0019BittnTestLang2Parser\u0000:\v@kinds{\rI\"\rCodeNode\u0006;\aT:\bobjI\"\rLineNode\u0006;\aT;\fI\"\rFuncNode\u0006;\aT;\fI\"\u000EIdensNode\u0006;\aT:\ttypeI\"\u000EParamNode\u0006;\aT;\fI\"\u000EValueNode\u0006;\aT;\fI\"\u0010StringNodee\u0006;\aT;\rI\"\u0010IntegerNode\u0006;\aT;\r:\t@obj{\v:\tcode\"\u0011\u0004\bc\rCodeNode:\tline\"\u0011\u0004\bc\rLineNode:\tfunc\"\u0011\u0004\bc\rFuncNode:\nparam\"\u0012\u0004\bc\u000EParamNode:\nvalue\"\u0012\u0004\bc\u000EValueNode:\vassign\"\u0013\u0004\bc\u000FAssignNode:\n@type{\t:\nidens\"\u0012\u0004\bc\u000EIdensNode:\vstring\"\u0013\u0004\bc\u000FStringNode:\finteger\"\u0014\u0004\bc\u0010IntegerNode:\bvar\"\u0010\u0004\bc\fVarNode"

class Lang
  def initialize
    @name = "BittnTestLang2"
    @version = Gem::Version.create("0.0.0-dev")
    @parser = Marshal.dump(BittnTestLang2Parser.new)
    @kinds = {
      "CodeNode" => :obj,
      "LineNode" => :obj,
      "FuncNode" => :obj,
      "IdensNode" => :type,
      "ParamNode" => :obj,
      "ValueNode" => :obj,
      "StringNodee" => :type,
      "IntegerNode" => :type,
      "AssignNode" => :obj,
      "VarNode" => :type,
      "NvarNode" => :type
    }
    @obj = {
      # Marshal.dump(PrintNode.new)
      :code => Marshal.dump(CodeNode),
      :line => Marshal.dump(LineNode),
      :func => Marshal.dump(FuncNode),
      :param => Marshal.dump(ParamNode),
      :value => Marshal.dump(ValueNode),
      :assign => Marshal.dump(AssignNode)
    }
    @type = {
      :idens => Marshal.dump(IdensNode),
      :string => Marshal.dump(StringNode),
      :integer => Marshal.dump(IntegerNode),
      :var => Marshal.dump(VarNode),
      :nvar => Marshal.dump(NvarNode)
    }
  end
  def getName
    return @name
  end
  def getVersion
    return @version
  end
  def getParser
    return @parser
  end
  def getObj
    return @obj
  end
  def getType
    return @type
  end
  def getKinds
    return @kinds
  end
end

class CodeNode
  def initialize(data)
    @data = data
  end
  def call()
    @data.each do |hash|
      Marshal.load(hash[0]).call
    end
  end
  def class_name
    self.class.name
  end
end

class LineNode
  def initialize(data)
    @data = data
  end
  def call()
    Marshal.load(@data[0][0]).call
  end
  def class_name
    self.class.name
  end
end

class FuncNode
  def initialize(data)
    @data = data
  end
  def call()
    # p Marshal.load(@data[0][1])
    idens = Marshal.load(@data[0][0]).exec
    if @data.size==1
      param = ""
    else
      param = Marshal.load(@data[0][1]).call
    end

    case idens
    when "print"
      PrintNode.new(param).call
    when "date"
      DateNode.new(param).call
    else
      raise BittnError,"#{idens}という関数はありません"
    end
  end
  def class_name
    self.class.name
  end
end


class PrintNode
  def initialize(data)
    @data = data
  end
  def call()
    print(@data)
  end
end


class DateNode
  def initialize(data)
    @data = data
  end
  def call()
    return Time.now.to_s
  end
end

class IdensNode
  def initialize(data)
    @data = data
  end
  def exec()
    return @data.to_s
  end
  def class_name
    self.class.name
  end
end

class ParamNode
  def initialize(data)
    @data = data
  end
  def call()
    Marshal.load(@data[0][0]).call
  end
  def class_name
    self.class.name
  end
end

class ValueNode
  def initialize(data)
    @data = data
  end
  def call()
    Marshal.load(@data[0][0]).exec
  end
  def class_name
    self.class.name
  end
end

class StringNode
  def initialize(data)
    @data = data
  end
  def exec()
    # p @data
    return @data[:chars].to_s.gsub(/\\n/,"\n")
  end
  def class_name
    self.class.name
  end
end

class IntegerNode
  def initialize(data)
    @data = data
  end
  def exec()
    return data[0].to_i
  end
  def class_name
    self.class.name
  end
end

class VarNode
  def initialize(data)
    @data = data
  end
  def exec()
    if $var[@data.to_s]==nil
      raise BittnError,"#{@data.to_s}という変数はありません"
    else
      return $var[@data.to_s]
    end
  end
  def class_name
    self.class.name
  end
end

class NvarNode
  def initialize(data)
    @data = data
  end
  def exec()
    return @data.to_s
  end
  def class_name
    self.class.name
  end
end

class AssignNode
  def initialize(data)
    @data = data
  end
  def call()
    var = Marshal.load(@data[0][0]).exec
    value = Marshal.load(@data[0][1]).call
    $var[var] = value
  end
  def class_name
    self.class.name
  end
end
