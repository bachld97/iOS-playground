import React from 'react';
import logo from './logo.svg';
import CodeBlock from "./CodeBlock";

import './App.css';

import blogMarkdownFile from './content/README.md'

const ReactMarkdown = require('react-markdown/with-html')

class App extends React.Component {
	constructor(props) {
		super(props);
		this.state = {
			markdownContent: null
		};
	}

	componentDidMount() {
		fetch(blogMarkdownFile)
			.then(response => {
				return response.text()
			})
			.then(text => {
				this.setState({ markdownContent: text });
			});
	}

	render() {
		return (
			<div className="App">
				<BlogHeader />
				<BlogBody content={this.state.markdownContent}/>
			</div>
		);
	}
}


class BlogHeader extends React.Component {
  render() {
    return (
      <div className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <h1> 
          BBlog
        </h1>
      </div>
    )
  }
}

class BlogBody extends React.Component {
  render() {
    return (
      <div className="App-body">
				<ReactMarkdown 
          source={this.props.content}
          renderers={{ code: CodeBlock }}
        />
      </div>
    )
  }
}

export default App;
