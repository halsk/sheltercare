/** @jsx React.DOM */
var TodoList = React.createClass({displayName: "TodoList",
  render: function() {
    var _this = this;
    var createItem = function(item, index) {
      return (
        React.createElement("li", {key:  index }, 
           item.gender, " | ", item.age, 
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
    var firebaseRef = firebase.database().ref('/items');
    this.bindAsArray(firebaseRef.limitToLast(25), 'items');
  },

  onChange: function(e) {
    this.setState({text: e.target.value});
  },

  removeItem: function(key) {
    var firebaseRef = firebase.database().ref('/items');
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
        React.createElement(TodoList, {items:  this.state.items, removeItem:  this.removeItem})

      )
    );
  }
});

ReactDOM.render(React.createElement(TodoApp, null), document.getElementById('todoApp'));
