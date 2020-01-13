import React from 'react';
import MarkdownView from '../shared/MarkdownView';


class HomePage extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            markdownContent: null
        };
    }

    componentDidMount() {
        fetch(this.props.blogRootPath)
            .then(response => response.text())
            .then(text => this.setState({ markdownContent: text}));
    }

    render() {
        return (
            <MarkdownView 
                content={this.state.markdownContent}
            />

        );
    }
}

export default HomePage;