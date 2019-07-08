<dfkv-highlight>
  <script type="text/javascript">
    var tag = this;

    tag.on('mount', function() {
      var terms = tag.opts.terms;
      var str = tag.opts.contents || '';

      if (terms) {
        var regex = new RegExp(terms, 'gi');
        str = str.replace(regex, function(m) {
          return '<mark>' + m + '</mark>'}
        );
      }

      jQuery(tag.root).html(str);
    });
  </script>
</dfkv-highlight>