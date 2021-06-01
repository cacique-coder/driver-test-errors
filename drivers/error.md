There was a problem expanding macro '__build_helpers__'

Called macro defined in lib/placeos-driver/src/placeos-driver.cr:225:3

 225 | macro __build_helpers__

Which expanded to:

    1 |
    2 |
    3 |     # [] <- in case we need to filter out more classes
    4 |
    5 |
    6 |
    7 |
    8 |     # Filter out abstract methods
    9 |
   10 |
   11 |     # A class that handles executing every public method defined
   12 |     # NOTE:: currently doesn't handle multiple methods signatures (except block
   13 |     # and no block). Technically we could add the support however the JSON
   14 |     # parsing does not reliably pick the closest match and instead picks the
   15 |     # first or simplest match. So simpler to have a single method signature for
   16 |     # all public API methods
   17 |     class KlassExecutor
   18 |       def initialize(json : String)
   19 |         @lookup = Hash(String, JSON::Any).from_json(json)
   20 |         @exec = @lookup["__exec__"].as_s
   21 |       end
   22 |
   23 |       @lookup : Hash(String, JSON::Any)
   24 |       @exec : String
   25 |
   26 |       EXECUTORS = {
   27 |
   28 |       }  of String => Nil
   29 |
   30 |       def execute(klass : Wcp::StaffAPI) : Task | String
   31 |         json = @lookup[@exec]
   32 |         executor = EXECUTORS[@exec]?
   33 |         raise "execute requested for unknown method: #{@exec} on #{klass.class}" unless executor
   34 |         executor.call(json, klass)
   35 |       end
   36 |
   37 |       # provide introspection into available functions
   38 |       @@functions : String?
   39 |       @@interface : String?
   40 |
   41 |       def self.functions
   42 |         functions = @@interface
   43 |         return {functions, @@functions.not_nil!} if functions
   44 |
 > 45 |         @@interface = iface = {
   46 |
   47 |         }.to_json
   48 |
   49 |         @@functions = funcs = {
   50 |
   51 |         }.to_json
   52 |
   53 |         {iface, funcs}
   54 |       end
   55 |
   56 |       class_getter security : String do
   57 |         Hash(String, Array(String)).new { |h, k| h[k] = [] of String }.tap { |sec|
   58 |
   59 |         }.to_json
   60 |       end
   61 |
   62 |       class_getter metadata : String do
   63 |         implements = ["PlaceOS::Driver", "Reference", "Object"].reject { |obj| IGNORE_KLASSES.includes?(obj) }
   64 |         iface, funcs = self.functions
   65 |
   66 |         %({
   67 |           "interface": #{iface},
   68 |           "functions": #{funcs},
   69 |           "implements": #{implements.to_json},
   70 |           "requirements": #{Utilities::Discovery.requirements.to_json},
   71 |           "security": #{self.security}
   72 |         }).gsub(/\s/, "")
   73 |       end
   74 |
   75 |       # unlike metadata, the schema is not required for runtime
   76 |       def self.metadata_with_schema
   77 |         meta = metadata.rchop
   78 |         schema = PlaceOS::Driver::Settings.get { generate_json_schema }
   79 |         %(#{meta},"settings":#{schema}})
   80 |       end
   81 |     end
   82 |
Error: for empty hashes use '{} of KeyType => ValueType'