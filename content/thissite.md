
## Learning Web development

### CSS

* CSS Selector *

| Selector |   Example   |               Description               |
|:--------:|:-----------:|:---------------------------------------:|
| .class   | .intro      | Selects elements with class="intro"     |
| #id      | #firstname  | Selects the element with id="firstname" |
| element  | p, div, ... | Select all <p>, <div>, and ... elements |
| *        | *           | Select all elements                     |


* CSS Insertion *

There are 3 ways to insert style sheet:

* External CSS: Use separated css file(s)
* Internal CSS: CSS is embeded in <style> tag of HTML
* Inline CSS: CSS is embeded at element level

CSS loading will override existing CSS definition: If external CSS is loaded before internal CSS, conflicting properties will follow interal CSS.
Inline style is the last to be loaded, as a result, it overrides external and/or internal CSS.

* CSS Color *

* Text color: color: #.....;
* Background color: background-color: #.....;
* Border color: border: 2px solid #.....;

CSS color format:
* rgb(255, 255, 255)
* #ffffff
* hsl(9, 100%, 100%)
* rgba(255, 255, 255, 0.5)

* CSS Background *

* background-color
* background-image
* background-repeat
* background-attachment
* background-position

* CSS Border *

The following values are allowed:

* dotted - Defines a dotted border
* dashed - Defines a dashed border
* solid - Defines a solid border
* double - Defines a double border
* groove - Defines a 3D grooved border. The effect depends on the border-color value
* ridge - Defines a 3D ridged border. The effect depends on the border-color value
* inset - Defines a 3D inset border. The effect depends on the border-color value
* outset - Defines a 3D outset border. The effect depends on the border-color value
* none - Defines no border
* hidden - Defines a hidden border

The border-style property can have from one to four values (for the top border, right border, bottom border, and the left border

Other border properties:
* border-width
* border-color

We can set individual side for border:
```css
border-top-style: dotted;
border-right-style: solid;

/* Short hand */
border-style: dotted solid solid dotted /* top right bottom left */
border-style: dotted solid dotted /* top right/left bottom */
border-style: solid dotted /* top/bot left/right */
```

To create rouned border, use `border-radius`

* CSS Margin* 

Defines space around elements, outside borders

* `margin: auto` can be used to child view in parent.
* `margin: inherit` can be used by child to use the same margin as parent.

Margin collapse: top/bottom margin of 2 elements can be collapsed (only larger margin is kept). For example: TopView has bot margin of 20px, while BottomView has top margin of 15px, TopView will be 20px away from BottomView (not 20 + 15 = 35px).
