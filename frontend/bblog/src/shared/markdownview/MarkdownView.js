import React, { PureComponent } from "react";
import PropTypes from "prop-types";
import { Prism as SyntaxHighlighter } from "react-syntax-highlighter";
import { atomDark as codeEditorTheme } from "react-syntax-highlighter/dist/cjs/styles/prism";
import '../../App.css';
import InlineCode from "./InlineCode";
import MarkdownLink from "./MarkdownLink";

const ReactMarkdown = require('react-markdown/with-html')

class MarkdownView extends React.Component {
    render() {
        return (
            <ReactMarkdown className="MarkdownView"
                source={this.props.content}
                renderers={{ 
                  code: CodeBlock, 
                  inlineCode: InlineCode,
                  link: MarkdownLink,
                }}
            />
        )
    }
}

class CodeBlock extends PureComponent {
  static propTypes = {
    value: PropTypes.string.isRequired,
    language: PropTypes.string
  };

  static defaultProps = {
    language: null
  };

  render() {
    const { language, value } = this.props;
    const codeLanguage = language ? language.toLowerCase() : null;

    return (
      <SyntaxHighlighter 
        language={codeLanguage} 
        style={codeEditorTheme}>   
         {value}
      </SyntaxHighlighter>
    );
  }
}

export default MarkdownView;
