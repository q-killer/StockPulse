package com.github.premnirmal.ticker.model;

import android.content.Context;
import android.widget.Toast;

import com.github.premnirmal.ticker.network.QueryCreator;
import com.github.premnirmal.ticker.network.StocksApi;
import com.github.premnirmal.ticker.network.historicaldata.HistoricalData;
import com.github.premnirmal.ticker.network.historicaldata.History;
import com.github.premnirmal.ticker.network.historicaldata.Quote;
import com.jjoe64.graphview.series.DataPoint;

import org.joda.time.DateTime;

import java.util.Collections;

import rx.Observable;
import rx.Subscriber;
import rx.android.schedulers.AndroidSchedulers;
import rx.functions.Action1;
import rx.functions.Func1;
import rx.schedulers.Schedulers;

/**
 * Created by premnirmal on 12/30/14.
 */
public class HistoryProvider implements IHistoryProvider {

    private final StocksApi stocksApi;
    private final Context context;

    public HistoryProvider(StocksApi stocksApi, Context context) {
        this.stocksApi = stocksApi;
        this.context = context;
    }

    @Override
    public Observable<History> getHistory(final String ticker) {
        return Observable.create(new Observable.OnSubscribe<History>() {
            @Override
            public void call(final Subscriber<? super History> subscriber) {
                final DateTime now = DateTime.now();
                final String query = QueryCreator.buildHistoricalDataQuery(ticker, now.minusYears(1), now);
                stocksApi.getHistory(query)
                        .observeOn(AndroidSchedulers.mainThread())
                        .subscribeOn(Schedulers.io())
                        .doOnError(new Action1<Throwable>() {
                            @Override
                            public void call(Throwable throwable) {
                                Toast.makeText(context, "Error", Toast.LENGTH_SHORT).show();
                            }
                        })
                        .map(new Func1<HistoricalData, HistoricalData>() {
                            @Override
                            public HistoricalData call(HistoricalData historicalData) {
                                Collections.sort(historicalData.query.mResult.quote);
                                return historicalData;
                            }
                        })
                        .subscribe(new Action1<HistoricalData>() {
                            @Override
                            public void call(HistoricalData response) {
                                subscriber.onNext(response.query.mResult);
                                subscriber.onCompleted();
                            }
                        });
            }
        });
    }

    @Override
    public Observable<DataPoint[]> getDataPoints(String ticker) {
        return getHistory(ticker)
                .map(new Func1<History, DataPoint[]>() {
                    @Override
                    public DataPoint[] call(History history) {
                        final DataPoint[] dataPoints = new DataPoint[history.quote.size()];
                        for(int i = 0; i < history.quote.size(); i++) {
                            final Quote quote = history.quote.get(i);
                            final DataPoint point = new DataPoint(quote.getDate().toDate(),quote.mClose);
                            dataPoints[i] = point;
                        }
                        return dataPoints;
                    }
                });
    }
}
