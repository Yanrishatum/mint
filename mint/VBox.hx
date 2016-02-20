package mint;
import mint.Control;
import mint.layout.margins.Margins;

/**
 * ...
 * @author Yanrishatum
 */
class VBox extends Control
{
  
  private var _margin:Float;
  public var margin(get, set):Float;
  private inline function get_margin():Float { return _margin; }
  private inline function set_margin(v:Float):Float
  {
    if (v != _margin)
    {
      _margin = v;
      updateMargins();
    }
    return v;
  }
  
  private var _align:AnchorType;
  public var align(get, set):AnchorType;
  private inline function get_align():AnchorType { return _align; }
  private inline function set_align(v:AnchorType):AnchorType
  {
    if (v == AnchorType.bottom || v == AnchorType.top || v == AnchorType.center_y) _align = AnchorType.left;
    if (_align != v)
    {
      _align = v;
      updateMargins();
    }
    return _align;
  }
  
  public function new(_options:ControlOptions, _emit_oncreate:Bool = false) 
  {
    _options.mouse_input = true;
    _options.key_input = true;
    super(_options, _emit_oncreate);
    _align = AnchorType.left;
    _margin = 1;
    onchildadd.listen(childAdd);
    onchildremove.listen(childRemove);
    onbounds.listen(updateMargins);
  }
  
  private function childAdd(control:Control):Void
  {
    updateMargins();
    control.onbounds.listen(updateMargins);
  }
  
  private function childRemove(control:Control):Void
  {
    control.onbounds.remove(updateMargins);
    updateMargins();
  }
  
  private var _ignore:Bool = false;
  private function updateMargins():Void
  {
    if (_ignore) return;
    _ignore = true;
    
    var w:Float = this.w_min;
    for (child in children)
    {
      if (w < child.w) w = child.w;
    }
    if (this.w_max != 0 && this.w_max < w) w = this.w_max;
    
    var offset:Float = 0;
    for (child in children)
    {
      child.x_local = switch (_align)
      {
        case AnchorType.right:
          w - child.w;
        case AnchorType.center_x:
          (w - child.w) / 2;
        default:
          0;
      }
      
      child.y_local = offset;
      offset += child.h + _margin;
    }
    set_size(w, offset - _margin);
    _ignore = false;
  }
  
}