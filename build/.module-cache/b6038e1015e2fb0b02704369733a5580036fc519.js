/** @jsx React.DOM */
var ExampleComponent = React.createClass({displayName: "ExampleComponent",
  mixins: [ReactFireMixin],
  // ...
});
var TodoList = React.createClass({displayName: "TodoList",
  render: function() {
    var _this = this;
    var createItem = function(item, index) {
      return (
        React.createElement("li", {key:  index }, 
           item.text, 
          React.createElement("span", {onClick:  _this.props.removeItem.bind(null, item['.key']), 
                style: { color: 'red', marginLeft: '10px', cursor: 'pointer'}}, 
            "X"
          )
        )
      );
    };
    return React.createElement("ul", null,  this.props.items.map(createItem) );
  }
});

var TodoApp = React.createClass({displayName: "TodoApp",
  mixins: [ReactFireMixin],

  getInitialState: function() {
    return {
      items: [],
      text: ''
    };
  },

  componentWillMount: function() {
    var firebaseRef = firebase.database().ref('todoApp/items');
    this.bindAsArray(firebaseRef.limitToLast(25), 'items');
  },

  onChange: function(e) {
    this.setState({text: e.target.value});
  },

  removeItem: function(key) {
    var firebaseRef = firebase.database().ref('todoApp/items');
    firebaseRef.child(key).remove();
  },

  handleSubmit: function(e) {
    e.preventDefault();
    if (this.state.text && this.state.text.trim().length !== 0) {
      this.firebaseRefs['items'].push({
        text: this.state.text
      });
      this.setState({
        text: ''
      });
    }
  },

  render: function() {
    return (
      React.createElement("div", null, 
        React.createElement(TodoList, {items:  this.state.items, removeItem:  this.removeItem}), 
        React.createElement("form", {onSubmit:  this.handleSubmit}, 
          React.createElement("input", {onChange:  this.onChange, value:  this.state.text}), 
          React.createElement("button", null,  'Add #' + (this.state.items.length + 1) )
        )
      )
    );
  }
});

ReactDOM.render(React.createElement(TodoApp, null), document.getElementById('todoApp'));
