# mk_html_template

def mk_html_template(home, sec_prev, sec_next)
  template = <<~EOS
  <!DOCTYPE html>
  <html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="generator" content="pandoc" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
    <title>$title$</title>
    <style>
      code{white-space: pre-wrap;}
      span.smallcaps{font-variant: small-caps;}
      span.underline{text-decoration: underline;}
      div.column{display: inline-block; vertical-align: top; width: 50%;}
      div.hanging-indent{margin-left: 1.5em; text-indent: -1.5em;}
      ul.task-list{list-style: none;}
      pre{overflow: visible;}
      pre > code.sourceCode { white-space: pre; position: relative; }
      pre > code.sourceCode > span { display: inline-block; line-height: 1.25; }
      pre > code.sourceCode > span:empty { height: 1.2em; }
      code.sourceCode > span { color: inherit; text-decoration: inherit; }
      div.sourceCode { margin: 1em 0; }
      pre.sourceCode { margin: 0; }
      @media screen {
      div.sourceCode { overflow: auto; }
      }
      @media print {
      pre > code.sourceCode { white-space: pre-wrap; }
      pre > code.sourceCode > span { text-indent: -5em; padding-left: 5em; }
      }
      pre.numberSource code
        { counter-reset: source-line 0; }
      pre.numberSource code > span
        { position: relative; left: -4em; counter-increment: source-line; }
      pre.numberSource code > span > a:first-child::after
        { content: counter(source-line);
          position: relative; left: -1em; text-align: right; vertical-align: baseline;
          border: none; display: inline-block;
          -webkit-touch-callout: none; -webkit-user-select: none;
          -khtml-user-select: none; -moz-user-select: none;
          -ms-user-select: none; user-select: none;
          padding: 0 4px; width: 4em;
          color: #aaaaaa;
        }
      pre.numberSource { margin-left: 3em; border-left: 1px solid #aaaaaa;  padding-left: 4px; }
      div.sourceCode
        {   }
      @media screen {
      pre > code.sourceCode > span > a:first-child::before { text-decoration: underline; }
      }
      code span.al { color: #ff0000; font-weight: bold; } /* Alert */
      code span.an { color: #60a0b0; font-weight: bold; font-style: italic; } /* Annotation */
      code span.at { color: #7d9029; } /* Attribute */
      code span.bn { color: #40a070; } /* BaseN */
      code span.bu { } /* BuiltIn */
      code span.cf { color: #007020; font-weight: bold; } /* ControlFlow */
      code span.ch { color: #4070a0; } /* Char */
      code span.cn { color: #880000; } /* Constant */
      code span.co { color: #60a0b0; font-style: italic; } /* Comment */
      code span.cv { color: #60a0b0; font-weight: bold; font-style: italic; } /* CommentVar */
      code span.do { color: #ba2121; font-style: italic; } /* Documentation */
      code span.dt { color: #902000; } /* DataType */
      code span.dv { color: #40a070; } /* DecVal */
      code span.er { color: #ff0000; font-weight: bold; } /* Error */
      code span.ex { } /* Extension */
      code span.fl { color: #40a070; } /* Float */
      code span.fu { color: #06287e; } /* Function */
      code span.im { } /* Import */
      code span.in { color: #60a0b0; font-weight: bold; font-style: italic; } /* Information */
      code span.kw { color: #007020; font-weight: bold; } /* Keyword */
      code span.op { color: #666666; } /* Operator */
      code span.ot { color: #007020; } /* Other */
      code span.pp { color: #bc7a00; } /* Preprocessor */
      code span.sc { color: #4070a0; } /* SpecialChar */
      code span.ss { color: #bb6688; } /* SpecialString */
      code span.st { color: #4070a0; } /* String */
      code span.va { color: #19177c; } /* Variable */
      code span.vs { color: #4070a0; } /* VerbatimString */
      code span.wa { color: #60a0b0; font-weight: bold; font-style: italic; } /* Warning */
      div.sourceCode { margin: 10px; padding: 16px 10px 8px 10px; border: 2px solid silver; background-color: ghostwhite; overflow-x:scroll}
      pre:not(.sourceCode) { margin: 10px; padding: 16px 10px 8px 10px; border: 2px solid silver; background-color: ghostwhite; overflow-x:scroll}
      table {margin-left: auto; margin-right: auto; border-collapse: collapse; border: 1px solid;}
      th {padding: 2px 6px; border: 1px solid; background-color: ghostwhite;}
      td {padding: 2px 6px; border: 1px solid;}
      img {display: block; margin-left: auto; margin-right: auto;}
      figcaption {text-align: center;}
    </style>
  </head>
  <body style="padding-top: 70px;">
    <div class="container">
    <nav class="navbar fixed-top navbar-expand-lg navbar-dark bg-primary">
      <div class="container-fluid">
        <span class="navbar-brand">Gtk4 tutorial</span>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
          <ul class="navbar-nav me-auto mb-2 mb-lg-0">
            @@@home
            @@@prev
            @@@next
          </ul>
        </div>
      </div>
    </nav>
      <div class="row justify-content-center">
        <div class="col-xl-10 col-xxl-9">
$body$
        </div>
      </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
  </body>
  </html>
  EOS

  if home == nil
    template = template.sub(/@@@home/,'')
  else
    template = template.sub(/@@@home/, "<li class=\"nav-item\">\n<a class=\"nav-link\" href=\"#{home}\">Home</a>\n</li>\n")
  end
  if sec_prev == nil
    template = template.sub(/@@@prev/,'')
  else
    i = sec_prev.match(/\d+/).to_a[0]
    template = template.sub(/@@@prev/, "<li class=\"nav-item\">\n<a class=\"nav-link\" href=\"#{sec_prev}\">Prev: section#{i}</a>\n</li>\n")
  end
  if sec_next == nil
    template = template.sub(/@@@next/,'')
  else
    i = sec_next.match(/\d+/).to_a[0]
    template = template.sub(/@@@next/, "<li class=\"nav-item\">\n<a class=\"nav-link\" href=\"#{sec_next}\">Next: section#{i}</a>\n</li>\n")
  end
  File.write("docs/template.html", template)
end
