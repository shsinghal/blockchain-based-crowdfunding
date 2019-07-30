import React, { Component } from 'react';
import { Form, Button, Input, Message } from 'semantic-ui-react';
import Layout from '../../components/Layout';
import factory from '../../ethereum/factory';
import web3 from '../../ethereum/web3';
import Campaign from '../../ethereum/campaign';
import { Router } from '../../routes';

class Campaigndetail extends Component {
  state = {
    description: '',
    date:'',
    errorMessage: '',
    loading: false
  };

static async getInitialProps(props) {
    const { address } = props.query;

    return { address };
  }
  onSubmit = async event => {
    event.preventDefault();

    const campaign = Campaign(this.props.address);

    this.setState({ loading: true, errorMessage: '' });

    try {
      const accounts = await web3.eth.getAccounts();
      await campaign.methods
      .addDet(this.state.description,this.state.date)
      .send({ from: accounts[0]});
      
      Router.pushRoute(`/campaigns/${this.props.address}`);

    } 
    catch (err) {
      this.setState({ errorMessage: err.message });
    }

    this.setState({ loading: false});
  };

  render() {
    return (
     <Layout>
        <h3>Create a Campaign</h3>

        <Form onSubmit={this.onSubmit} error={!!this.state.errorMessage}>
          <Form.Field>
            <label>Description</label>
            <Input
              value={this.state.descriptions}
              onChange={event =>
                this.setState({ description: event.target.value })}
            />
            <label>Date</label>
            <Input
              value={this.state.date}
              onChange={event =>
                this.setState({ date: event.target.value })}
            />
          </Form.Field>

		<Message error header="Oops!" content={this.state.errorMessage} />
          <Button loading={this.state.loading} primary>
            Create!
          </Button>
        </Form>
      </Layout>
    );
  }
}


export default Campaigndetail;
