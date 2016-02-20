package mint;
import mint.Control;
import mint.layout.margins.Margins.AnchorType;

/**
 * ...
 * @author Yanrishatum
 */
class HBox extends Control
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
    if (v == AnchorType.left || v == AnchorType.right || v == AnchorType.center_x) _align = AnchorType.top;
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
    
    var h:Float = this.h_min;
    for (child in children)
    {
      if (h < child.h) h = child.h;
    }
    if (this.h_max != 0 && this.h_max < h) h = this.h_max;
    
    var offset:Float = 0;
    for (child in children)
    {
      child.y_local = switch (_align)
      {
        case AnchorType.bottom:
          h - child.h;
        case AnchorType.center_y:
          (h - child.h) / 2;
        default:
          0;
      }
      
      child.x_local = offset;
      offset += child.w + _margin;
    }
    set_size(offset - _margin, h);
    _ignore = false;
  }
  
}